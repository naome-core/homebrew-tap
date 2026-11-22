# NAOME Homebrew tap

Install the NAOME node command on Apple Silicon macOS or the standalone archive CLI through Homebrew.

```sh
brew install naome-core/tap/naome-network
brew install naome-core/tap/naome-protocol
```

| Formula | Command | Installation |
| --- | --- | --- |
| `naome-network` | `naome` | Installs the published Apple Silicon macOS executable. |
| `naome-protocol` | `nao` from v0.1.6, `rep` in v0.1.5 | Builds the CLI from the published Cargo source package with Homebrew-managed Rust. |

The fully qualified names also add the tap. Homebrew versions with tap trust grant trust to the named formula. You can then use `brew install naome-network` and `brew install naome-protocol` with the configured tap.

Run `naome --version` or `nao --version` to verify the installed command.

- The [NAOME Network quickstart](https://github.com/naome-core/naome-network#start-a-local-node) covers node setup. Stop a running node and back up its archive, coordination database and node key before upgrading `naome-network`.
- The [nao quickstart](https://github.com/naome-core/naome-protocol) covers standalone offline archives. Rust applications can add the protocol library as a Cargo dependency.
- Install the `naome-codex` plugin directly in Codex.

## Release updates

Publishing a stable release in either NAOME repository starts the [release sync workflow](https://github.com/naome-core/homebrew-tap/actions/workflows/sync-releases.yml). Run it from the Actions tab to retry a sync.

Publish an immutable `vX.Y.Z` release with the corresponding asset.

- Network uses `naome-network-vX.Y.Z-macos-arm64.tar.gz`.
- Protocol uses `naome-protocol-X.Y.Z.crate`.

The workflow takes the asset URL and SHA-256 from GitHub. It tests `naome-network` on Apple Silicon and `naome-protocol` on Apple Silicon and Linux before pushing updates to `main`. Run `brew update`, then `brew upgrade naome-network naome-protocol` to install the published versions.
