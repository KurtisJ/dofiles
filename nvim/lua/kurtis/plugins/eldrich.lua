return {
  "eldritch-theme/eldritch.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true, -- Built-in support for transparency!
    terminal_colors = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
  config = function(_, opts)
    require("eldritch").setup(opts)
    vim.cmd("colorscheme eldritch")

    -- Ensuring your specific Alacritty background stays put
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
}
