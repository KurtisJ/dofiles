return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      -- Enable the experimental file system watcher
      experimental_watch_for_changes = true,
      default_file_explorer = true, -- This replaces Netrw
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      view_options = {
        show_hidden = true, -- Essential for MERN (.env, .gitignore, etc.)
      },
      win_options = {
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
      },
      confirmation = {
        border = "rounded",
        win_options = {
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        },
      },
      -- Customizing the floating window to match your Eldritch theme
      float = {
        padding = 2,
        max_width = 80,  -- Fixed width looks cleaner on small screens
        max_height = 20, -- Keeps it from hitting the top/bottom
        border = "rounded",
        win_options = {
          winblend = 0, -- Set to 10 if you want a slight transparency
        },
      },
      keymaps = {
        ["<Esc>"] = "actions.close",
        ["q"] = "actions.close", -- 'q' is also a standard way to quit floats
        ["-"] = false,           -- Disable Oil's '-' mapping to allow Harpoon to work
      },
    })
    -- Force Oil to refresh whenever you focus the window
    vim.api.nvim_create_autocmd("FocusGained", {
      pattern = "oil://*",
      callback = function()
        require("oil").refresh()
      end,
    })
  end,
}
