local nnoremap = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

-- Show diagnostic message in a floating window
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

--nnoremap("pv", vim.cmd.Ex, "Open Netrw")
-- Telescope 
local builtin = require('telescope.builtin')
nnoremap("<leader>pf", builtin.find_files, "Find Files")
nnoremap("<leader>pg", builtin.live_grep, "Live Grep")

-- Exit Insert mode by typing 'jk' quickly
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit Insert mode" })

-- Open Oil file explorer
vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- The 'float' argument tells the Oil command exactly how to behave
--vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open oil float" })

-- Format the current buffer
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format current buffer" })
