return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
    opts = {
      -- Allow the plugin to work in terminal buffers
      render_modes = { 'n', 'c', 't', 'v' },
      file_types = { 'markdown', 'terminal' }, -- Add terminal to the allowed list
      win_options = {
        wrap = { default = true, rendered = true },
        linebreak = { default = true, rendered = true },
      },
    },
  }
}
