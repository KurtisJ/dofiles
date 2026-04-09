# Repository Guidelines

## Project Structure & Module Organization
This repository is a personal Neovim configuration written in Lua. `init.lua` is the entrypoint and loads `lua/kurtis/set.lua`, `lua/kurtis/init.lua`, and `lua/kurtis/remaps.lua`. Core behavior lives under `lua/kurtis/`, while plugin specs are split into focused files under `lua/kurtis/plugins/` such as `lsp.lua`, `telescope.lua`, and `treesitter.lua`. Plugin versions are pinned in `lazy-lock.json`.

## Build, Test, and Development Commands
Use Neovim itself as the development runtime.

- `nvim` launches the config locally.
- `nvim --headless "+Lazy! sync" +qa` installs or updates plugins defined through `lazy.nvim`.
- `nvim --headless "+checkhealth" +qa` runs Neovim health checks and catches missing external tools.
- `nvim --headless "+qa"` is a quick smoke test to confirm the config loads without startup errors.

If a plugin has a native build step, keep it working locally; for example, Telescope FZF depends on `make`.

## Coding Style & Naming Conventions
Follow the existing Lua style: 2-space indentation in most files, `snake_case` for locals and helper functions, and small module files with a single clear responsibility. Plugin spec files should return a Lua table compatible with `lazy.nvim`. Prefer descriptive module names like `terminal.lua` or `ai_assist.lua`. Keep keymaps grouped by concern and place reusable logic in `lua/kurtis/` instead of inline closures when it starts to grow.

## Testing Guidelines
There is no dedicated automated test suite yet. Validate changes with headless startup checks and manual verification inside Neovim. For plugin or LSP changes, test the affected workflow directly, such as `:Lazy sync`, opening a matching filetype, and confirming keymaps or diagnostics still work.

## Commit & Pull Request Guidelines
Git history currently starts with a simple `Initial commit`, so keep commit messages short, imperative, and specific, for example `Add Oil keymap descriptions` or `Fix Omnisharp startup command`. Pull requests should include a brief summary, note any external dependencies added, and attach screenshots or terminal output when UI behavior changes.

## Configuration Notes
Do not commit machine-specific secrets or tokens. External CLIs referenced by this config, including AI assistant tools and language servers, should be documented in the PR when introduced.
