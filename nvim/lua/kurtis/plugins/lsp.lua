-- 1. Global Diagnostic UI Setup (Stays at the top)
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN]  = "󰀪 ",
      [vim.diagnostic.severity.HINT]  = "󰌶 ",

      [vim.diagnostic.severity.INFO]  = "➔ ",
    },

  },

  float = { border = "rounded", source = "always" },
})

-- 2. Global Keybinds (Using the LspAttach autocmd)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  end,
})

return {
  {
    "williamboman/mason-lspconfig.nvim", -- Fixed the repo name
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- Initialize Mason first
      require("mason").setup()

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- 1. Servers Mason should manage
      local mason_servers = { "ts_ls", "html", "cssls", "eslint", "lua_ls", "omnisharp" }

      -- 2. ALL servers to enable (including Dart)
      local all_servers = { "ts_ls", "html", "cssls", "eslint", "lua_ls", "dartls", "omnisharp" }

      require("mason-lspconfig").setup({
        ensure_installed = mason_servers,
      })

      -- 3. The 0.11+ Enable Loop
      for _, server in ipairs(all_servers) do
        local config = { capabilities = capabilities }


        if server == "lua_ls" then
          config.settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
        elseif server == "dartls" then
          config.cmd = { "dart", "language-server", "--protocol=lsp" }
        elseif server == "omnisharp" then
          -- Remove "dotnet" from the start. The mason script handles it.
          config.cmd = { vim.fn.stdpath("data") .. "/mason/bin/omnisharp" }

          config.settings = {
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = true,
              EnableImportCompletion = true,
            },
          }
        end

        -- This registers the config and enables it for the filetype
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end

  }
}
