--v 1. Set leader first
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- OPTIONS
-- ============================================================================
vim.opt.number = true         -- line number
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true     -- highlight current line
vim.opt.wrap = false          -- do not wrap lines by default
vim.opt.scrolloff = 10        -- keep 10 lines above/below cursor vim.opt.sidescrolloff = 10 -- keep 10 lines to left/right of cursor
vim.opt.tabstop = 2           -- tabwidth
vim.opt.shiftwidth = 2        -- indent width
vim.opt.softtabstop = 2       -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = true      -- use spaces instead of tabs
vim.opt.smartindent = true    -- smart auto-indent
vim.opt.autoindent = true     -- copy indent from current line
vim.opt.termguicolors = true
vim.opt.ignorecase = true     -- case insensitive search
vim.opt.smartcase = true      -- case sensitive if uppercase in string
vim.opt.hlsearch = true       -- highlight search matches
vim.opt.incsearch = true      -- show matches as you type

vim.opt.signcolumn = "yes" -- always show a sign column
-- vim.opt.colorcolumn = "100" -- show a column at 100 position chars
vim.opt.showmatch = true                          -- highlights matching brackets
vim.opt.cmdheight = 1                             -- single line command line
vim.opt.completeopt = "menuone,noinsert,noselect" -- completion options
vim.opt.showmode = false                          -- do not show the mode, instead have it in statusline
vim.opt.pumheight = 10                            -- popup menu height
vim.opt.pumblend = 10                             -- popup menu transparency
vim.opt.winblend = 0                              -- floating window transparency
vim.opt.conceallevel = 0                          -- do not hide markup
vim.opt.concealcursor = ""                        -- do not hide cursorline in markup
vim.opt.lazyredraw = true                         -- do not redraw during macros
vim.opt.synmaxcol = 300                           -- syntax highlighting limit
vim.opt.fillchars = { eob = " " }                 -- hide "~" on empty lines

local undodir = vim.fn.expand("~/.vim/undodir")
if
    vim.fn.isdirectory(undodir) == 0 -- create undodir if nonexistent
then
  vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false                  -- do not create a backup file
vim.opt.writebackup = false             -- do not write to a backup file
vim.opt.swapfile = false                -- do not create a swapfile
vim.opt.undofile = true                 -- do create an undo file
vim.opt.undodir = undodir               -- set the undo directory
vim.opt.updatetime = 300                -- faster completion
vim.opt.timeoutlen = 500                -- timeout duration
vim.opt.ttimeoutlen = 0                 -- key code timeout
vim.opt.autoread = true                 -- auto-reload changes if outside of neovim
vim.opt.autowrite = false               -- do not auto-save

vim.opt.hidden = true                   -- allow hidden buffers
vim.opt.errorbells = false              -- no error sounds
vim.opt.backspace = "indent,eol,start"  -- better backspace behaviour
vim.opt.autochdir = false               -- do not autochange directories
vim.opt.iskeyword:append("-")           -- include - in words
vim.opt.path:append("**")               -- include subdirs in search
vim.opt.selection = "inclusive"         -- include last char in selection
vim.opt.mouse = "a"                     -- enable mouse support
vim.opt.clipboard:append("unnamedplus") -- use system clipboard
vim.opt.modifiable = true               -- allow buffer modifications
vim.opt.encoding = "utf-8"              -- set encoding

-- fg = The color of the character (Black)
-- bg = The color of the cursor block (Cyan/Aqua)
vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#00ffff" })
-- You also need to apply this to the "TermCursor" for when you use the terminal inside Neovim
vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250"

-- Folding: requires treesitter available at runtime; safe fallback if not
vim.opt.foldmethod = "expr"                          -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99                               -- start with all folds open

vim.opt.splitbelow = true                            -- horizontal splits go below
vim.opt.splitright = true                            -- vertical splits go right

vim.opt.wildmenu = true                              -- tab completion
vim.opt.wildmode =
"longest:full,full"                                  -- complete longest common match, full completion list, cycle through with Tab
vim.opt.diffopt:append("linematch:60")               -- improve diff display
vim.opt.redrawtime = 10000                           -- increase neovim redraw tolerance
vim.opt.maxmempattern = 20000                        -- increase max memory


vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#313244" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#89b4fa", bg = "#313244" })

-- Makes directory names pop in Oil
vim.api.nvim_set_hl(0, "OilDir", { fg = "#7aa2f7", bold = true })

vim.opt.autoread = true

-- Trigger autoread when the buffer changes or you switch back to Neovim
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Add this to your gemini_custom.lua or your keymap file
local ai = require("kurtis.ai_assist")

-- Toggle Windows
vim.keymap.set('n', '<leader>gg', function() ai.toggle('gemini') end)
vim.keymap.set('n', '<leader>cc', function() ai.toggle('claude') end)
vim.keymap.set('n', '<leader>xx', function() ai.toggle('codex') end)
-- These intercept the keys before they reach the CLI prompt
vim.keymap.set('t', '<leader>gg', function() ai.terminal_toggle('gemini') end)
vim.keymap.set('t', '<leader>cc', function() ai.terminal_toggle('claude') end)
vim.keymap.set('t', '<leader>xx', function() ai.terminal_toggle('codex') end)
-- Send Selection/File
vim.keymap.set({'n', 'v'}, '<leader>sg', function() ai.send_to('gemini') end)
vim.keymap.set({'n', 'v'}, '<leader>sc', function() ai.send_to('claude') end)
vim.keymap.set({'n', 'v'}, '<leader>sx', function() ai.send_to('codex') end)

-- Insert AI Comments (Normal Mode)
vim.keymap.set('n', '<leader>ic', function() ai.insert_ai_comment('claude') end, { desc = "Insert Claude Comment" })
vim.keymap.set('n', '<leader>ig', function() ai.insert_ai_comment('gemini') end, { desc = "Insert Gemini Comment" })
vim.keymap.set('n', '<leader>ix', function() ai.insert_ai_comment('codex') end,  { desc = "Insert Codex Comment" })

local term = require('kurtis.terminal')
-- Terminal Mappings (Independent)
vim.keymap.set('n', '<leader>tt', term.toggle, { desc = "Toggle Project Terminal" })
vim.keymap.set('t', '<leader>tt', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, false, true), 'n', true)
  vim.schedule(term.toggle)
end, { desc = "Hide Terminal" })

-- Optional: Escape to exit terminal mode easily
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

