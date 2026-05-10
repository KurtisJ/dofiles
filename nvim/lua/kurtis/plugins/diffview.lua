return {
  "sindrets/diffview.nvim",
  keys = {
    { "<leader>gv", "<CMD>DiffviewOpen<CR>", desc = "Open Diffview (Review all changes)" },
    { "<leader>gq", "<CMD>DiffviewClose<CR>", desc = "Close Diffview" },
  },
  config = function()
    -- Plugin-specific configuration can go here
  end
}
