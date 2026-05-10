-- Define a namespace for AI signs
local ai_ns = vim.api.nvim_create_namespace("ai_signs")

local function set_ai_colors()
  vim.api.nvim_set_hl(0, "AiSignGemini", { fg = "#be03fd", bold = true })
  vim.api.nvim_set_hl(0, "AiSignClaude", { fg = "#f27351", bold = true })
  vim.api.nvim_set_hl(0, "AiSignCodex", { fg = "#00ffcc", bold = true })
  
  -- Border Highlights
  vim.api.nvim_set_hl(0, "AiBorderGemini", { fg = "#be03fd" })
  vim.api.nvim_set_hl(0, "AiBorderClaude", { fg = "#f27351" })
  vim.api.nvim_set_hl(0, "AiBorderCodex",  { fg = "#00ffcc" })
end

set_ai_colors()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_ai_colors })

local M = {}

-- State now tracks multiple instances

local state = {
  instances = {
    gemini = { buf = -1, win = -1, cmd = "gemini" }, -- Adjust "gemini" to your actual CLI command
    claude = { buf = -1, win = -1, cmd = "claude" },

    codex  = { buf = -1, win = -1, cmd = "codex" },
  }
}

local function create_window(tool_name)
  local inst = state.instances[tool_name]
  local stats = vim.api.nvim_list_uis()[1]

  -- Maximize dimensions for "fullscreen" feel with a border
  local width = stats.width - 4
  local height = stats.height - 4
  local col = 1
  local row = 0

  if not vim.api.nvim_buf_is_valid(inst.buf) then
    inst.buf = vim.api.nvim_create_buf(false, true)
  end

  inst.win = vim.api.nvim_open_win(inst.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " " .. tool_name:upper() .. " ",
    title_pos = "center",
  })

  -- Apply the colored border
  local hl_name = "AiBorder" .. tool_name:sub(1, 1):upper() .. tool_name:sub(2)
  vim.wo[inst.win].winhighlight = "FloatBorder:" .. hl_name

  if vim.bo[inst.buf].buftype ~= "terminal" then
    vim.fn.termopen(inst.cmd)
  end
  vim.cmd("startinsert")
end

-- Toggle function that accepts the tool name
function M.toggle(tool)
  local inst = state.instances[tool]

  -- If we are CURRENTLY in the window for this tool, close it (hide)
  if vim.api.nvim_get_current_win() == inst.win then
    vim.api.nvim_win_close(inst.win, true)
    inst.win = -1 -- Reset so we know it's closed
    return
  end


  -- If the window is open elsewhere, jump to it
  if inst.win ~= -1 and vim.api.nvim_win_is_valid(inst.win) then
    vim.api.nvim_set_current_win(inst.win)
    vim.cmd("startinsert")
  else
    -- Otherwise, create it

    create_window(tool)
  end
end

-- Helper to handle the toggle safely from Terminal mode
function M.terminal_toggle(tool)
  -- Move out of Terminal mode so we can manipulate windows
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, false, true), 'n', true)
  vim.schedule(function()
    M.toggle(tool)
  end)
end

-- Generic send function
function M.send_to(tool)
  local inst = state.instances[tool]
  local mode = vim.api.nvim_get_mode().mode
  local file_path = vim.fn.expand("%:p")
  local prompt_prefix = ""


  if mode:match("[vV]") then
    local v_pos = vim.fn.getpos("v")
    local cur_pos = vim.fn.getpos(".")
    local line_start = math.min(v_pos[2], cur_pos[2])
    local line_end = math.max(v_pos[2], cur_pos[2])
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    prompt_prefix = string.format("@%s\nRegarding lines %d to %d: ", file_path, line_start, line_end)
  else
    prompt_prefix = string.format("@%s\nRegarding this file: ", file_path)
  end

  if not vim.api.nvim_win_is_valid(inst.win) then
    create_window(tool)
  end

  vim.schedule(function()
    local job_id = vim.b[inst.buf].terminal_job_id
    if job_id then
      -- Send Ctrl-U to clear line, then the prompt
      vim.api.nvim_chan_send(job_id, "\21" .. prompt_prefix)
      vim.api.nvim_set_current_win(inst.win)
      vim.cmd("startinsert")
    end
  end)
end

function M.insert_ai_comment(tool)
  local inst = state.instances[tool]
  -- Compatibility check for unpack
  local unpack = table.unpack or unpack


  -- Use pcall or a simple check for the commentstring library
  local status, ts_comment = pcall(require, 'ts_context_commentstring')
  local cs = (status and ts_comment.calculate_commentstring())
      or vim.bo.commentstring
      or "// %s"

  local tag = "@" .. tool .. ": "
  local final_text = string.format(cs, tag)

  -- This is where the error was happening
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { final_text })
  vim.api.nvim_buf_set_extmark(0, ai_ns, row - 1, 0, {
    sign_text = inst.icon,
    sign_hl_group = inst.hl,
    priority = 100,
  })

  vim.api.nvim_win_set_cursor(0, { row, #final_text })
  vim.cmd("startinsert")
end

-- Refresh icons for all tools
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("AiIcons", { clear = true }),
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    vim.api.nvim_buf_clear_namespace(bufnr, ai_ns, 0, -1)

    for i, line in ipairs(lines) do
      for tool, _ in pairs(state.instances) do
        if line:match("@" .. tool .. ":") then
          local hl = "AiSign" .. tool:sub(1, 1):upper() .. tool:sub(2)
          vim.api.nvim_buf_set_extmark(bufnr, ai_ns, i - 1, 0, {
            sign_text = "󰚽",
            sign_hl_group = hl,
          })
        end
      end
    end
  end,

})

return M
