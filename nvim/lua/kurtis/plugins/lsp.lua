-- 1. Global Diagnostic UI Setup
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

-- 2. Global Keybinds
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})

return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig", -- We NEED this so vim.lsp.enable finds the configs
    },
    config = function()
      config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- 1. Servers Mason SHOULD install
        local mason_servers = { "ts_ls", "html", "cssls", "eslint", "lua_ls" }

        -- 2. ALL servers Neovim should enable (including Dart)
        local all_servers = { "ts_ls", "html", "cssls", "eslint", "lua_ls", "dartls" }

        require("mason-lspconfig").setup({
          ensure_installed = mason_servers, -- Removed dartls from here
        })

        -- 3. The 0.11+ Enable Loop
        for _, server in ipairs(all_servers) do
          local config = { capabilities = capabilities }

          if server == "lua_ls" then
            config.settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
          elseif server == "dartls" then
            -- Tell Neovim to just use the 'dart' command from your PATH
            config.cmd = { "dart", "language-server", "--protocol=lsp" }
            config.settings = {
              dart = { completeFunctionCalls = true, showTodos = true }
            }
          end

          vim.lsp.config(server, config)
          vim.lsp.enable(server)
        end
      end
    end
  }
}
