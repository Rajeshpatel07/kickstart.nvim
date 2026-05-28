-- Barbar is a Neovim plugin for tabline/bufferline management
-- https://github.com/romgrk/barbar.nvim

-- 1. Initialize globals (Equivalent to lazy.nvim's `init = function() ... end`)
vim.g.barbar_auto_setup = false

-- 2. Define the main plugin and its dependencies
local plugins = {
  { src = 'https://github.com/romgrk/barbar.nvim', version = vim.version.range '*' },
  'https://github.com/lewis6991/gitsigns.nvim',       -- OPTIONAL: for git status
  'https://github.com/nvim-tree/nvim-web-devicons',   -- OPTIONAL: for file icons
}

-- 3. Load the plugins via the vim.pack API
vim.pack.add(plugins)

-- 4. Set Keymaps
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next/close
map('n', '<s-h>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<s-l>', '<Cmd>BufferNext<CR>', opts)
map('n', '<s-d>', '<Cmd>BufferClose<CR>', opts)

-- 5. Setup the plugin with options (Equivalent to lazy.nvim's `opts = { ... }`)
require('barbar').setup {
  animation = true,
  insert_at_start = true,
  tabpages = true,
  auto_hide = false,
  icons = {
    preset = 'default',
  },
}
