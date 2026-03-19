return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    
    -- 1. Ensure Dart is in the install list
    ts.install({ "javascript", "typescript", "tsx", "html", "css", "lua", "dart" })

    -- 2. Wake up Treesitter for Dart files
    vim.api.nvim_create_autocmd("FileType", {
      -- Added "dart" to the pattern below
      pattern = { "javascript", "typescript", "typescriptreact", "lua", "dart" },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
