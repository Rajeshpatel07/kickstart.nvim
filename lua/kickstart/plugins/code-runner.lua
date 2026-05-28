-- Modern, reusable function to open a floating terminal
local function open_floating_term(cmd, title)
  -- 1. Create a new, empty "scratch" buffer
  local bufnr = vim.api.nvim_create_buf(false, true)

  -- 2. Define the floating window's appearance dynamically
  local win_height = math.floor(vim.o.lines * 0.6)
  local win_width = math.floor(vim.o.columns * 0.6)
  local row = math.floor((vim.o.lines - win_height) / 2)
  local col = math.floor((vim.o.columns - win_width) / 2)

  local win_config = {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = title,         -- Modern UI addition: Adds a title to the top border
    title_pos = 'center',  -- Centers the title text
  }

  -- 3. Open the floating window
  vim.api.nvim_open_win(bufnr, true, win_config)

  -- 4. Start the terminal
  vim.fn.termopen(cmd, {
    on_exit = function()
      -- Use vim.schedule instead of an arbitrary 100ms defer.
      -- This safely queues the buffer deletion on the main event loop,
      -- preventing race conditions and UI flicker natively.
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end)
    end,
  })

  -- 5. Switch to insert mode using the native Lua command API
  vim.cmd.startinsert()
end

-- Keymap: Run Code
vim.keymap.set('n', '<leader>r', function()
  local filename = vim.fn.expand('%:t')
  local dir = vim.fn.expand('%:p:h')
  local filetype = vim.bo.filetype

  -- Quote the variables to prevent shell injection/errors with spaces
  local original_cmd = string.format('bash ~/.config/nvim/scripts/run-code.sh "%s" "%s" "%s"', filename, filetype, dir)
  local cmd_to_run = string.format("%s; printf '\\n\\nPress Enter to exit... '; read -r", original_cmd)

  open_floating_term(cmd_to_run, " Run Code ")
end, { desc = 'Run code in floating terminal' })

-- Keymap: Run Codeforces Tests
vim.keymap.set('n', '<leader>cr', function()
  local filename = vim.fn.expand('%:t')
  local dir = vim.fn.expand('%:p:h')
  local filetype = vim.bo.filetype

  if filetype ~= 'cpp' then
    -- Modern Neovim notification API instead of standard print
    vim.notify('Not a C++ file', vim.log.levels.WARN, { title = 'Codeforces Runner' })
    return
  end

  local original_cmd = string.format('bash ~/.config/nvim/scripts/codeforces.sh "%s" "%s" "%s"', filename, filetype, dir)
  local cmd_to_run = string.format("%s; printf '\\n\\nPress Enter to exit... '; read -r", original_cmd)

  open_floating_term(cmd_to_run, " Codeforces Tests ")
end, { desc = 'Run Codeforces tests in floating terminal' })
