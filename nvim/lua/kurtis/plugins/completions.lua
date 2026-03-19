return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",           -- Connection to your LSP
      "hrsh7th/cmp-buffer",             -- Suggest words from the current file
      "hrsh7th/cmp-path",               -- Suggest file paths
      "L3MON4D3/LuaSnip",               -- The snippet engine
      "saadparwaiz1/cmp_luasnip",       -- Connects snippets to the menu
      "onsails/lspkind.nvim",           -- Adds pretty icons (VS Code style)
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- The "Eldritch" UI Styling
        window = {
          completion = cmp.config.window.bordered({
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),           -- Previous suggestion
          ["<C-j>"] = cmp.mapping.select_next_item(),           -- Next suggestion
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),           -- Manually trigger menu
          ["<C-e>"] = cmp.mapping.abort(),                  -- Close menu
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        -- Where the suggestions come from (Order matters!)
        sources = cmp.config.sources({
          { name = "nvim_lsp" },           -- 1. Actual code logic
          { name = "luasnip" },            -- 2. Snippets
          { name = "buffer" },             -- 3. Words in current file
          { name = "path" },               -- 4. File system paths
        }),
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
        experimental = {
          ghost_text = true,
        },
      })
    end,
  },
}
