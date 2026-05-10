return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = "┃" },
        change       = { text = "┃" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle this if you want to see who wrote the line
      
      -- Keymaps specifically for git actions
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation through changes
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next Git hunk" })

        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev Git hunk" })

        -- Actions: Previewing and Resetting
        map("n", "<leader>hp", function() gs.preview_hunk_inline() end, { desc = "Preview Git hunk inline" })
        map("n", "<leader>gd", gs.diffthis, { desc = "Git Diff current file" })
        map("n", "<leader>gD", function() vim.cmd("diffoff!") end, { desc = "Turn off diff mode" })
        map("n", "<leader>hb", function() gs.blame_line{full=true} end, { desc = "Blame line" })

        -- Accept / Reject (Stage / Reset)
        map("n", "<leader>ga", gs.stage_hunk, { desc = "Git Accept (Stage) Hunk" })
        map("n", "<leader>gaa", gs.stage_buffer, { desc = "Git Accept (Stage) All in Buffer" })
        map("n", "<leader>gag", "<CMD>!git add -u<CR>", { desc = "Git Accept (Stage) ALL Project Changes" })

        map("n", "<leader>gr", gs.reset_hunk, { desc = "Git Reject (Reset) Hunk" })
        map("n", "<leader>grr", gs.reset_buffer, { desc = "Git Reject (Reset) All in Buffer" })
        map("n", "<leader>gRg", "<CMD>!git checkout .<CR>", { desc = "Git Reject (Reset) ALL Project Changes" })

        -- Inline Review Mode (Cursor-style)
        map("n", "<leader>gi", function()
          local config = require("gitsigns.config").config
          local is_on = config.linehl -- Check if it's currently on
          gs.toggle_linehl(not is_on)
          gs.toggle_deleted(not is_on)
          gs.toggle_word_diff(not is_on)
        end, { desc = "Toggle Inline Diff View" })
      end
    })
  end
}
