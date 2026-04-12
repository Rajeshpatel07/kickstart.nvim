return {
  'MeanderingProgrammer/render-markdown.nvim',
  after = { 'nvim-treesitter' },
  requires = { 'nvim-mini/mini.nvim', opt = true },
  config = function()
    require('render-markdown').setup {
      opts = {
        render_modes = { 'n', 'c', 't' },
      },
    }
  end,
}
