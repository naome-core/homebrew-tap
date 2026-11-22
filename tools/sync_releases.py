"""Refresh Homebrew source pins from published NAOME release assets."""

import json
from pathlib import Path
import re
import subprocess

FORMULAS = {
    "naome-network": "naome-network-v{version}-macos-arm64.tar.gz",
    "naome-protocol": "naome-protocol-{version}.crate",
}
VERSION = r"(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)"
SOURCE = re.compile(r'^  url "([^"]+)"\n  sha256 "([0-9a-f]{64})"$', re.MULTILINE)


def version_key(version):
    return tuple(map(int, version.split(".")))


def updated_source(name, source, release):
    """Return the revised formula or leave it pinned when no update is ready."""
    prefix = f"https://github.com/naome-core/{name}/releases/download"
    asset_name = FORMULAS[name].format
    pins = list(SOURCE.finditer(source))
    if len(pins) != 1:
        raise ValueError(f"{name}: expected one source URL and SHA-256 pin")

    pin = pins[0]
    pinned_url = pin[1]
    current_version = re.match(rf"{re.escape(prefix)}/v({VERSION})/", pinned_url)
    if current_version is None:
        raise ValueError(f"{name}: source URL is outside its versioned release path")
    current = current_version[1]
    if pinned_url != f"{prefix}/v{current}/{asset_name(version=current)}":
        raise ValueError(f"{name}: unexpected source asset")

    if release["draft"] or release["prerelease"]:
        return source
    tag = re.fullmatch(rf"v({VERSION})", release["tag_name"])
    if tag is None:
        print(f"::warning::{name}: latest release does not use a vX.Y.Z tag")
        return source
    version = tag[1]
    if version_key(version) <= version_key(current):
        print(f"{name}: already at {current}, latest is {version}")
        return source
    if not release.get("immutable"):
        print(f"::warning::{name}: release v{version} must be immutable")
        return source

    filename = asset_name(version=version)
    url = f"{prefix}/v{version}/{filename}"
    asset = next((item for item in release["assets"] if item["name"] == filename), None)
    if asset is None or asset["state"] != "uploaded" or asset["browser_download_url"] != url:
        print(f"::warning::{name}: release v{version} is missing the expected asset {filename}")
        return source
    digest = re.fullmatch(r"sha256:([0-9a-f]{64})", asset.get("digest") or "")
    if digest is None:
        print(f"::warning::{name}: release v{version} has no valid SHA-256 for {filename}")
        return source

    print(f"{name}: {current} -> {version}")
    replacement = f'  url "{url}"\n  sha256 "{digest[1]}"'
    return source[:pin.start()] + replacement + source[pin.end():]


def main():
    formula_root = Path(__file__).resolve().parent.parent / "Formula"
    for name in FORMULAS:
        release = json.loads(subprocess.check_output(
            ["gh", "api", f"repos/naome-core/{name}/releases/latest"], text=True,
        ))
        formula = formula_root / f"{name}.rb"
        source = formula.read_text(encoding="utf-8")
        updated = updated_source(name, source, release)
        if updated != source:
            formula.write_text(updated, encoding="utf-8")


if __name__ == "__main__":
    main()
