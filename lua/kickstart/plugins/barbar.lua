local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<s-h>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<s-l>', '<Cmd>BufferNext<CR>', opts)
map('n', '<s-d>', '<Cmd>BufferClose<CR>', opts)

return {
  'romgrk/barbar.nvim',
  version = '*',
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
    animation = true,
    insert_at_start = true,
    tabpages = true,
    auto_hide = false,
    icons = {
      preset = 'slanted',
    },
  },
}
