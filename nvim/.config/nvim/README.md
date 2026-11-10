# Neovim configuration

LazyVim with the existing custom Kanagawa palette and key bindings. The Python
and AI upgrade was tested on Neovim 0.12.6 and LazyVim 16.0.2. Plugin revisions
are recorded in `lazy-lock.json`; AI adapters have exact npm versions and a
`package-lock.json`.

## Python navigation

- BasedPyright provides definitions, references, completion, and type analysis.
- Native Ruff provides lint diagnostics, import organization, and formatting.
- `pylsp` is disabled so it does not compete with BasedPyright.
- `gd`, `gr`, and the existing completion/formatting bindings are unchanged.

Interpreter discovery respects an explicit LSP `pythonPath` first, then an
activated virtualenv/Conda environment, then a project `.venv`, `venv`, or
`.venv/<project-name>`. It falls back to Python on PATH. Keep the venv path rather
than its resolved symlink so installed dependencies remain visible. JYP's
`.venv/jyp/bin/python` is supported without a project-specific hardcoded path.

Use the existing `<leader>cv` / `:VenvSelect` to select another environment.
`:LspInfo` should show `basedpyright` and `ruff` attached to Python files.
Framework-generated members (for example dynamic Django managers) still depend
on the environment's installed dependencies and available type information.

Tested Mason tool versions can be installed with:

```vim
:MasonInstall basedpyright@1.40.2 ruff@0.17.4
```

## Claude and Codex

Avante requires Neovim 0.12 or newer. Its stable v0.5.0 release is pinned, and its
build hook downloads the matching upstream native libraries instead of requiring
Rust. On macOS it also fixes the v0.5.0 artifacts' CI-only libiconv path to use
the system library, then signs the repaired libraries locally. Install the
pinned ACP adapters after cloning or changing their lockfile:

```sh
npm ci --prefix ~/.config/nvim/ai
```

Reinstall native libraries with `:Lazy build avante.nvim` so the macOS repair
hook runs as well.

Sign in to the Claude/Codex CLI as usual. Avante defaults to Claude Code through
the official ACP adapter; no model or API key is hardcoded in this configuration.
Use `:AvanteSwitchProvider` to select `codex` instead.

| Command | Action |
| --- | --- |
| `:AvanteAsk` | Open the Avante sidebar / ask about code |
| `:AvanteChat` | Open a chat |
| `:AvanteEdit` | Edit selected code |
| `:AvanteSwitchProvider` | Select Claude Code or Codex |
| `:AvanteStop` | Stop the current request |
| `:Claude` | Toggle the Claude CLI terminal through Sidekick |
| `:Codex` | Toggle the Codex CLI terminal through Sidekick |
| `:Sidekick cli send msg="{selection}"` | Send visual context to a CLI |
| `:Sidekick cli prompt` | Pick a context-aware CLI prompt |

Avante's automatic key mappings and suggestions are disabled. Sidekick's Next
Edit Suggestions are disabled, preserving existing Copilot and completion
bindings. Existing theme and keymap source files are unchanged. Sidekick uses
tmux for terminal persistence; its Codex command preserves terminal scrollback.
Avante keeps normal tool-permission confirmation enabled.

## Verification and rollback

Before the upgrade, commit `0b34038` captured the existing local Neovim edits.
The subsequent upgrade commit includes configuration, plugin and adapter locks.
To undo the upgrade, find that commit with `git log --oneline -- nvim`, then:

```sh
git revert <upgrade-commit>
```

Restart Neovim, run `:Lazy restore` to restore the plugin lockfile, and restart
again. Mason tools and npm adapter installations are not stored in Git and may
remain installed after reverting. They are unused by the restored config.
The old Homebrew Neovim 0.11.5 keg was retained during the editor upgrade. If an
editor rollback is also needed, its executable is:

```sh
DYLD_LIBRARY_PATH=/opt/homebrew/Cellar/tree-sitter/0.25.10/lib \
  /opt/homebrew/Cellar/neovim/0.11.5/bin/nvim
```

Validation covered Python LSP attachment and interpreter selection in JYP,
`Booking` definition lookup and 41 references, cross-file navigation in a small
fixture, theme and mapping comparison, AI plugin loading, native libraries, and
both ACP initialization handshakes through Avante itself. No paid AI prompt is
needed for these checks.
