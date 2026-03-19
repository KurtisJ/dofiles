return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "eldritch", -- This will automatically sync with your theme
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
