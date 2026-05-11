-- Show diagnostic message in a floating window
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- Exit Insert mode by typing 'jk' quickly
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit Insert mode" })

-- Format the current buffer
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format current buffer" })

-- ============================================================================
-- CORE TOOLS (Oil & Telescope)
-- ============================================================================
-- Using <CMD> ensures the plugins lazy-load correctly
vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open Oil (File Explorer)" })
vim.keymap.set("n", "<leader>pf", "<CMD>Telescope find_files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>pg", "<CMD>Telescope live_grep<CR>",  { desc = "Live Grep" })
vim.keymap.set("n", "<leader>gl", function() require("kurtis.review_list").toggle() end, { desc = "AI Change Review List" })

-- ============================================================================
-- AI ASSISTANT (Toggles & Communication)
-- ============================================================================
local ai = require("kurtis.ai_assist")

-- Toggle Windows
vim.keymap.set('n', '<leader>gg', function() ai.toggle('gemini') end, { desc = "Toggle Gemini" })
vim.keymap.set('n', '<leader>cc', function() ai.toggle('claude') end, { desc = "Toggle Claude" })
vim.keymap.set('n', '<leader>xx', function() ai.toggle('codex') end,  { desc = "Toggle Codex" })

-- Terminal inter-mode toggles (allows <leader>gg to work while inside terminal)
vim.keymap.set('t', '<leader>gg', function() ai.terminal_toggle('gemini') end)
vim.keymap.set('t', '<leader>cc', function() ai.terminal_toggle('claude') end)
vim.keymap.set('t', '<leader>xx', function() ai.terminal_toggle('codex') end)

-- Send Selection/File to AI
vim.keymap.set({'n', 'v'}, '<leader>sg', function() ai.send_to('gemini') end, { desc = "Send to Gemini" })
vim.keymap.set({'n', 'v'}, '<leader>sc', function() ai.send_to('claude') end, { desc = "Send to Claude" })
vim.keymap.set({'n', 'v'}, '<leader>sx', function() ai.send_to('codex') end,  { desc = "Send to Codex" })

-- Insert AI Comments
vim.keymap.set('n', '<leader>ic', function() ai.insert_ai_comment('claude') end, { desc = "Insert Claude Comment" })
vim.keymap.set('n', '<leader>ig', function() ai.insert_ai_comment('gemini') end, { desc = "Insert Gemini Comment" })
vim.keymap.set('n', '<leader>ix', function() ai.insert_ai_comment('codex') end,  { desc = "Insert Codex Comment" })

-- ============================================================================
-- TERMINAL
-- ============================================================================
local term = require('kurtis.terminal')

vim.keymap.set('n', '<leader>tt', term.toggle, { desc = "Toggle Project Terminal" })
vim.keymap.set('t', '<leader>tt', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, false, true), 'n', true)
  vim.schedule(term.toggle)
end, { desc = "Hide Terminal" })

-- Escape to exit terminal mode easily
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
