# NAOME Homebrew tap

Install the NAOME node command on Apple Silicon macOS or the standalone REP archive command through Homebrew.

```sh
brew install naome-core/tap/naome-network
brew install naome-core/tap/naome-protocol
```

| Formula | Command | Installation |
| --- | --- | --- |
| `naome-network` | `naome` | Installs the published Apple Silicon macOS executable. |
| `naome-protocol` | `rep` | Builds the CLI from the published Cargo source package with Homebrew-managed Rust. |

The fully qualified names also add the tap. Homebrew versions with tap trust grant trust to the named formula. You can then use `brew install naome-network` and `brew install naome-protocol` with the configured tap.

Run `naome --version` or `rep --version` to verify the command is available.

- The [NAOME Network quickstart](https://github.com/naome-core/naome-network#start-a-local-node) covers node setup. Stop a running node and back up its archive, coordination database and node key before upgrading `naome-network`.
- The [REP quickstart](https://github.com/naome-core/naome-protocol#use-an-offline-archive) covers standalone offline archives. Rust applications can add the protocol library as a Cargo dependency.
- Install the `naome-codex` plugin directly in Codex.

## Release updates

The [release sync workflow](https://github.com/naome-core/homebrew-tap/actions/workflows/sync-releases.yml) checks the latest stable releases every 15 minutes. Run it from the Actions tab to check immediately. GitHub can suspend scheduled workflows after 60 days of repository inactivity. Re-enable the workflow in Actions if that happens.

Publish an immutable `vX.Y.Z` release with the corresponding asset.

- Network uses `naome-network-vX.Y.Z-macos-arm64.tar.gz`.
- Protocol uses `naome-protocol-X.Y.Z.crate`.

The workflow takes the asset URL and SHA-256 from GitHub. It tests `naome-network` on Apple Silicon and `naome-protocol` on Apple Silicon and Linux before pushing updates to `main`. Run `brew update`, then `brew upgrade naome-network naome-protocol` to install the published versions.
