return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      experimental_watch_for_changes = true,
      default_file_explorer = true,
      columns = { "icon" },
      view_options = { show_hidden = true },
      win_options = { winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder" },
      confirmation = {
        border = "rounded",
        win_options = { winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder" },
      },
      float = {
        padding = 2,
        max_width = 80,
        max_height = 20,
        border = "rounded",
        win_options = { winblend = 0 },
      },
      keymaps = {
        ["<Esc>"] = "actions.close",
        ["q"] = "actions.close",
        ["-"] = false,
      },
    })
    vim.api.nvim_create_autocmd("FocusGained", {
      pattern = "oil://*",
      callback = function()
        require("oil").refresh()
      end,
    })
  end,
}
