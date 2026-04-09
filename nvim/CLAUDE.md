# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration in Lua using **lazy.nvim** as the plugin manager.

## Common Commands

- `nvim` — launch with this config
- `nvim --headless "+Lazy! sync" +qa` — install/update plugins
- `nvim --headless "+checkhealth" +qa` — run health checks
- `nvim --headless "+qa"` — smoke test (confirms config loads without errors)

Telescope FZF native requires `make` for its build step.

## Architecture

**Bootstrap chain:** `init.lua` → requires `kurtis/set.lua` (options & keymaps), `kurtis/init.lua` (lazy.nvim bootstrap), `kurtis/remaps.lua` (telescope/oil/format keymaps), `kurtis/filetype.lua` (Pick BASIC detection).

**Plugin loading:** `lua/kurtis/init.lua` bootstraps lazy.nvim and auto-discovers all plugin specs from `lua/kurtis/plugins/` via `{ import = "kurtis.plugins" }`. Each file returns a lazy.nvim-compatible table. Versions pinned in `lazy-lock.json`.

**Custom modules** (in `lua/kurtis/`):
- `ai_assist.lua` — Multi-tool AI integration (Gemini, Claude, Codex) with floating windows, selection sending, and inline comment insertion. Keymaps defined in `set.lua`.
- `terminal.lua` — Floating terminal toggle locked to project root.
- `filetype.lua` — Custom Pick BASIC language detection for extensionless files using keyword scoring.

**LSP stack:** Mason → mason-lspconfig → nvim-lspconfig. Configured servers: ts_ls, html, cssls, eslint, lua_ls, dartls, omnisharp, roslyn (C#).

**Completion:** nvim-cmp with LuaSnip, sources for LSP, buffer, and path.

**Key keybindings** (leader = space):
- `<leader>gg/cc/xx` — toggle Gemini/Claude/Codex AI windows
- `<leader>sg/sc/sx` — send selection/file to AI tools
- `<leader>ic/ig/ix` — insert AI tool comments
- `<leader>tt` — toggle floating terminal

## Code Style

- 2-space indentation, `snake_case` for locals/helpers
- Small focused modules with single responsibility
- Plugin specs return lazy.nvim-compatible tables
- Keymaps grouped by concern in `set.lua` and `remaps.lua`
- No automated test suite — validate via headless startup and manual testing
