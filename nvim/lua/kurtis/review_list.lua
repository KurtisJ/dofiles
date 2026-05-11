local M = {}

-- Helper to get the absolute path to the git root
local function get_git_root()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  local result = handle:read("*a")
  handle:close()
  return result:gsub("%s+", "")
end

-- Helper to get modified and untracked files
local function get_modified_files()
  local root = get_git_root()
  if root == "" then return {} end

  local handle = io.popen("git status --porcelain")
  local result = handle:read("*a")
  handle:close()

  local files = {}
  for line in result:gmatch("[^\r\n]+") do
    -- Porcelain status: "XY path/to/file"
    -- X = Status of the index (staged)
    -- Y = Status of the work tree (unstaged)
    local status = line:sub(1, 2)
    local path = line:sub(4)

    -- Strip quotes if present
    path = path:gsub('^"', ''):gsub('"$', '')

    -- We only want to show files that have UNSTAGED changes (Y != " ")
    -- or are UNTRACKED (??).
    -- Once a file is staged (Accepted), Y becomes " ", and it disappears from this list.
    if status:sub(2, 2) ~= " " or status == "??" then
      -- Prepend git root to make it an absolute path
      local full_path = root .. "/" .. path
      -- Only add if it's a file (not a directory)
      if vim.fn.isdirectory(full_path) == 0 then
        table.insert(files, full_path)
      end
    end
  end
  return files
end

function M.toggle()
  local full_paths = get_modified_files()
  local display_names = {}
  local is_empty = #full_paths == 0

  if is_empty then
    -- Centered-ish message for empty state
    display_names = {
      "",
      "",
      "        No changes to review!        ",
      "",
      "",
    }
  else
    -- Create short names for display (just relative to current dir or filename)
    local cwd = vim.fn.getcwd() .. "/"
    for _, path in ipairs(full_paths) do
      local short = path:gsub(cwd, "")
      table.insert(display_names, short)
    end
  end

  -- Create buffer for the float
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, display_names)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "review_list"

  -- Window dimensions (centered)
  local width = 80
  local height = math.max(5, math.min(#display_names, 15))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " 🌿 AI Change Review 🌿 ",
    title_pos = "center",
  })

  -- Keymaps for the list buffer
  local opts = { buffer = buf, silent = true }

  -- Close mappings
  vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, true) end, opts)
  vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win, true) end, opts)

  -- Selection mapping (only if not empty)
  if not is_empty then
    vim.keymap.set("n", "<CR>", function()
      local cursor = vim.api.nvim_win_get_cursor(win)
      local idx = cursor[1]
      local file_path = full_paths[idx]

      if file_path then
        -- Close the window BEFORE trying to edit, so focus returns to the original window
        vim.api.nvim_win_close(win, true)

        -- Use 'confirm edit' to handle unsaved changes in the current buffer gracefully
        local ok, err = pcall(function()
          vim.cmd("confirm edit " .. vim.fn.fnameescape(file_path))
        end)

        if not ok then
          vim.notify("Could not open file: " .. tostring(err), vim.log.levels.ERROR)
          return
        end

        -- Auto-enable Inline Review Mode
        local gs_ok, gs = pcall(require, "gitsigns")
        if gs_ok then
          gs.toggle_linehl(true)
          gs.toggle_deleted(true)
          gs.toggle_word_diff(true)
        end
      end
    end, opts)
  else
    -- Empty state: Hide cursor and allow any key to close
    local original_cursor = vim.opt.guicursor:get()

    -- Autocmds to hide/restore cursor
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      buffer = buf,
      callback = function()
        vim.opt.guicursor = "a:ver0" -- Make it invisible/zero-width
      end,
    })

    vim.api.nvim_create_autocmd({ "BufLeave", "BufDelete" }, {
      buffer = buf,
      callback = function()
        vim.opt.guicursor = original_cursor
      end,
    })

    -- Map almost everything to close the window
    local any_keys = {
      "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
      "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
      "<CR>", "<Space>", "<BS>", "<Tab>", "<S-Tab>",
      "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "=", "+", "[", "]", "{", "}", ";", ":", "'", "\"", ",", ".",
      "/", "?", "\\", "|", "`", "~"
    }
    for _, key in ipairs(any_keys) do
      vim.keymap.set("n", key, function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end, opts)
    end
  end
end

return M
