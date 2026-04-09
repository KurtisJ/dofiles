return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local catppuccin_lualine = require("catppuccin.utils.lualine")()

        require("lualine").setup({
            options = {
                theme = catppuccin_lualine,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                globalstatus = true, -- One single bar at the bottom, even with splits
            },
            sections = {
                lualine_a = { { "mode", separator = { right = "" }, right_padding = 2 } },
                lualine_b = { "filename", "branch" },
                lualine_c = { "diagnostics" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { { "location", separator = { left = "" }, left_padding = 2 } },
            },
        })
    end,
}
