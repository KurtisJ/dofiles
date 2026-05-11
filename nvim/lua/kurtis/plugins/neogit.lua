return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>gs", "<CMD>Neogit<CR>", desc = "Open Neogit Status" },
  },
  config = function()
    require("neogit").setup({
      integrations = {
        diffview = true,
      },
    })
  end,
}
