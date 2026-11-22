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

Update each formula against an immutable upstream release asset and its SHA-256 digest. Verify the installed command with `brew test naome-network` or `brew test naome-protocol` before publishing the change.
