-- Define a namespace for Gemini signs
local gemini_ns = vim.api.nvim_create_namespace("gemini_signs")

-- Setup the highlight group (Eldritch Purple)
-- Bright Neon Purple/Magenta for high visibility
local function set_gemini_colors()
  vim.api.nvim_set_hl(0, "GeminiSign", {
    fg = "#be03fd",
    bold = true,
    force = true     -- Ensure it overrides other settings
  })
end

-- Run it now
set_gemini_colors()

-- Run it every time the colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_gemini_colors
})
-- Optional: Add a subtle background to make it look like a button
-- vim.api.nvim_set_hl(0, "GeminiSign", { fg = "#be03fd", bg = "#2e1a47", bold = true })
local M = {}

local state = {
  buf = -1,
  win = -1,
}

local function create_floating_window()
  local stats = vim.api.nvim_list_uis()[1]
  local width = math.floor(stats.width * 0.8)
  local height = math.floor(stats.height * 0.8)
  local col = math.floor((stats.width - width) / 2)
  local row = math.floor((stats.height - height) / 2) - 2

  if not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  })

  if vim.bo[state.buf].buftype ~= "terminal" then
    vim.fn.termopen("gemini")
  end
  vim.cmd("startinsert")
end

function M.toggle_gemini()
  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  else
    create_floating_window()
  end
end

function M.send_to_gemini()
  local mode = vim.api.nvim_get_mode().mode
  local file_path = vim.fn.expand("%:p")
  local prompt_prefix = ""

  if mode:match("[vV]") then
    -- VISUAL MODE: Get specific lines
    local v_pos = vim.fn.getpos("v")
    local cur_pos = vim.fn.getpos(".")
    local line_start = math.min(v_pos[2], cur_pos[2])
    local line_end = math.max(v_pos[2], cur_pos[2])

    -- Exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    prompt_prefix = string.format("@%s\nRegarding lines %d to %d: ", file_path, line_start, line_end)
  else
    -- NORMAL MODE: Reference the whole file
    prompt_prefix = string.format("@%s\nRegarding this file: ", file_path)
  end

  -- Open/focus Gemini window
  if not vim.api.nvim_win_is_valid(state.win) then
    create_floating_window()
  end

  vim.schedule(function()
    local job_id = vim.b[state.buf].terminal_job_id
    if job_id then
      -- Clear current line in terminal (Ctrl-U) and send our reference
      vim.api.nvim_chan_send(job_id, "\21" .. prompt_prefix)

      vim.api.nvim_set_current_win(state.win)
      vim.cmd("startinsert")
    end
  end)
end

function M.insert_gemini_comment()
  local unpack = table.unpack or unpack

  local commentstring = require('ts_context_commentstring').calculate_commentstring()
      or vim.bo.commentstring
      or "// %s"

  local gemini_tag = "@gemini: "
  local final_text = string.format(commentstring, gemini_tag)

  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  -- 1. Insert the comment line
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { final_text })

  -- 2. Add the icon to the Sign Column (extmark)
  -- Note: row-1 is the 0-indexed position of the NEW line we just added
  vim.api.nvim_buf_set_extmark(0, gemini_ns, row - 1, 0, {
    sign_text = "󰚽",
    sign_hl_group = "GeminiSign",
    priority = 100, -- Higher than git, lower than errors
  })

  vim.api.nvim_win_set_cursor(0, { row, #final_text })
  vim.cmd("startinsert")
end

-- Automatically add icons to existing @gemini: comments on file open
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("GeminiIcons", { clear = true }),
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Clear old signs before refreshing
    vim.api.nvim_buf_clear_namespace(bufnr, gemini_ns, 0, -1)

    for i, line in ipairs(lines) do
      if line:match("@gemini:") then
        vim.api.nvim_buf_set_extmark(bufnr, gemini_ns, i - 1, 0, {
          sign_text = "󰚽",
          sign_hl_group = "GeminiSign",
        })
      end
    end
  end,
})
local suggestion = ""
local ns_id = vim.api.nvim_create_namespace("gemini_completion")

function M.get_completion()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  
  -- Get context (20 lines above, 5 below)
  local start_line = math.max(0, line - 20)
  local end_line = line + 5
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)
  local context = table.concat(lines, "\n")

  -- Clear previous suggestion
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

  -- Call Gemini CLI in non-interactive mode
  local cmd = string.format("gemini --non-interactive 'Complete the code at the cursor. Only return the completion text, no markdown. Context:\n%s'", context)
  
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and data[1] ~= "" then
        suggestion = data[1]
        -- Show virtual text (Ghost Text)
        vim.api.nvim_buf_set_extmark(bufnr, ns_id, line - 1, cursor[2], {
          virt_text = {{ suggestion, "Comment" }}, -- Use Comment highlight for the "ghost" look
          virt_text_pos = "overlay",
        })
      end
    end,
  })
end

function M.accept_completion()
  if suggestion ~= "" then
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_put({ suggestion }, "c", true, true)
    -- Clear after accepting
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    suggestion = ""
  end
end
return M
