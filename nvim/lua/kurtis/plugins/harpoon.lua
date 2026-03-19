return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({})

    -- Basic settings
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    -- KEYMAPS
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end,
      { desc = "Harpoon: Mark File" })

    -- Toggle the Harpoon UI menu
    vim.keymap.set("n", "-", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Harpoon: Show Menu" })

    -- Select files 1-4 directly
    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

    -- Optional: Telescope integration to see your marks in a fuzzy finder
    vim.keymap.set("n", "<leader>sh", function() toggle_telescope(harpoon:list()) end,
      { desc = "Open Harpoon window in Telescope" })
  end
}
