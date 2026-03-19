return {
  "nvim-telescope/telescope.nvim",
  -- We need the latest 'master' or '0.1.x' to get the fix for the ft_to_lang error
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } -- Highly recommended for speed
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        -- This forces Telescope to use a safer previewer logic
        preview = {
          treesitter = false, -- Temporary fix: set to false if the error persists
        },
      },
      fzf = {
        fuzzy = false,                -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,  -- override the file sorter
        case_mode = "smart_case",     -- or "ignore_case" or "respect_case"
      }
    })

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search inside code" })
  end,
}
