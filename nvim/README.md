# Kurtis's Neovim Configuration

A modular, high-performance Neovim setup optimized for **AI-assisted development** and **Git-driven workflows**.

## 🏗️ Architecture

The configuration is organized into a modular structure under `lua/kurtis/`:

- **`init.lua`**: The entry point. Bootstraps the plugin manager and loads the modules.
- **`lua/kurtis/set.lua`**: Core Vim options (`vim.opt`) and global settings.
- **`lua/kurtis/remaps.lua`**: Global keybindings and utility mappings (AI, Terminal, Navigation).
- **`lua/kurtis/plugins/`**: Individual plugin specifications. Each file handles the installation and configuration of a specific tool.
- **`lua/kurtis/ai_assist.lua`**: Custom logic for floating AI terminal windows (Gemini, Claude, Codex).

---

## ⌨️ Keybindings

The leader key is set to `SPACE`.

### 🤖 AI Assistant
Integrated tools for interacting with LLMs directly within Neovim.

| Key | Action |
|-----|--------|
| `<leader>gg` | Toggle Gemini window |
| `<leader>cc` | Toggle Claude window |
| `<leader>xx` | Toggle Codex window |
| `<leader>sg` | Send Selection/File to Gemini |
| `<leader>sc` | Send Selection/File to Claude |
| `<leader>sx` | Send Selection/File to Codex |
| `<leader>ig` | Insert Gemini comment tag |
| `<leader>ic` | Insert Claude comment tag |
| `<leader>ix` | Insert Codex comment tag |

### 🌿 Git & Review Workflow
Customized for reviewing AI-generated code changes.

| Key | Action |
|-----|--------|
| `<leader>gs` | **Neogit**: Open Neogit status (Magit-style interface) |
| `<leader>gl` | **Review List**: Open a Harpoon-like list of all modified files. |
| `<leader>gv` | **Global Review**: Open Diffview side-by-side for all project changes |
| `<leader>gd` | **Split Diff**: Compare current file with Git index |
| `<leader>gi` | **Inline Review**: Toggle highlights, deleted lines, and word-diffs |
| `<leader>gD` | **Diff Off**: Turn off all active diff modes |
| `<leader>ga` | **Accept Hunk**: Stage the current block of changes |
| `<leader>gaa` | **Accept Buffer**: Stage all changes in the current file |
| `<leader>gag` | **Accept Global**: Stage all project-wide changes (`git add -u`) |
| `<leader>gr` | **Reject Hunk**: Undo/Reset the current block of changes |
| `<leader>grr` | **Reject Buffer**: Undo/Reset all changes in the current file |
| `<leader>gRg` | **Reject Global**: Undo/Reset ALL project-wide changes |

---

## 🚀 The AI Review Workflow

1.  Run a Gemini task.
2.  Press **`<leader>gl`** to see the list of modified files.
3.  Select a file and press **`Enter`**. The file opens with **Inline Diff Mode** automatically enabled.
4.  Review using **`<leader>ga`** (Accept) or **`<leader>gr`** (Reject).
5.  Once you've accepted/rejected all changes in a file, it will disappear from the `<leader>gl` list the next time you open it.

### 📂 Navigation & Tools
| Key | Action |
|-----|--------|
| `<leader>pv` | **Oil**: Open file explorer in parent directory |
| `<leader>pf` | **Telescope**: Find Files (fuzzy search) |
| `<leader>pg` | **Telescope**: Live Grep (search text in project) |
| `<leader>tt` | **Terminal**: Toggle floating project terminal |
| `jk` | Fast escape from Insert mode |

### 🛠️ LSP & Diagnostics
| Key | Action |
|-----|--------|
| `gd` | Go to Definition |
| `gr` | List References |
| `K`  | Hover documentation |
| `<leader>ca` | Code Actions |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format current buffer |
| `<leader>d` | Show line diagnostics in float |

---

## 🚀 Getting Started

### Prerequisites
- Neovim 0.10+
- [Lazy.nvim](https://github.com/folke/lazy.nvim) (Bootstrapped automatically)
- A Nerd Font (e.g., JetBrainsMono) for icons.

### Installation
1. Clone this repo into `~/.config/nvim`.
2. Open Neovim; `lazy.nvim` will automatically install all plugins.
3. Run `:Mason` to manage LSP servers and debuggers.

---

## 🎨 Theme
The setup uses **Eldritch** (or Catppuccin) with custom transparency and border highlights to match the AI assistant's color-coded interface.
