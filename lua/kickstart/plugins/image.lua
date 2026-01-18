return {
  {
    '3rd/image.nvim',
    build = false,
    opts = {
      backend = 'kitty',
      processor = 'magick_rock', -- Optimizes performance
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'markdown', 'vimwiki', 'html' },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'norg' },
        },
      },

      -- GEOMETRY & SIZING
      -- We remove the hard '12' line limit so images can actually scale up.
      max_width = nil,
      max_height = nil,

      -- This controls the size relative to your window.
      -- 100% width allows full detail.
      -- 50% height prevents inline markdown images from taking over the entire screen,
      -- but is still large enough for "full buffer" viewing.
      max_width_window_percentage = 100,
      max_height_window_percentage = 95,

      -- FULL BUFFER MODE
      -- This is the magic setting. It tells Neovim: "When I open these files,
      -- don't show text, just render the image."
      hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },

      -- UI BEHAVIOR
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', 'Neo-tree' },
      editor_only_render_when_focused = false, -- Allow images to stay visible when you switch windows
      tmux_show_only_in_active_window = false,
    },
  },
}
