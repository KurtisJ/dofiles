return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- This version of nvim-treesitter uses .setup() directly on the main module
    require("nvim-treesitter").setup({
      -- Fixes "Invalid node type 'tab'" by ensuring we have compatible parsers for Neovim's queries
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "dart",
        "markdown",
        "markdown_inline",
      },
      highlight = {
        enable = true,
      },
    })
  end,
}
