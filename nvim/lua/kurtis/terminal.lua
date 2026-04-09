-- ~/.config/nvim/lua/terminal.lua
local M = {}

local state = {
  buf = -1,
  win = -1,
  root_dir = vim.fn.getcwd(), -- Locked to launch directory
}

function M.toggle()
  -- If we are currently inside the terminal window, close it
  if vim.api.nvim_get_current_win() == state.win then
    vim.api.nvim_win_close(state.win, true)
    return
  end

  -- If window exists elsewhere, jump to it
  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_set_current_win(state.win)
    vim.cmd("startinsert")
    return
  end

  -- Otherwise, create it
  if not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end

  local stats = vim.api.nvim_list_uis()[1]
  local width = math.floor(stats.width * 0.8)

  local height = math.floor(stats.height * 0.8)


  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((stats.width - width) / 2),
    row = math.floor((stats.height - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " TERMINAL ",
    title_pos = "center",
  })

  if vim.bo[state.buf].buftype ~= "terminal" then
    vim.fn.termopen(vim.o.shell, { cwd = state.root_dir })
  end
  vim.cmd("startinsert")
end

return M

