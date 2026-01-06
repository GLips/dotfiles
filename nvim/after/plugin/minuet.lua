-- Minuet AI - AI-powered autocomplete
local status_ok, minuet = pcall(require, 'minuet')
if not status_ok then
  return
end

-- Helper function to read API key from .env file or environment variable
local function get_api_key()
  -- First try environment variable
  local env_key = vim.fn.getenv('NEOVIM_OPENROUTER_API_KEY')
  if env_key ~= vim.NIL and env_key ~= '' then
    return env_key
  end

  -- Fall back to reading from Neovim .env file
  local env_file = vim.fn.expand('~/.config/nvim/.env')
  if vim.fn.filereadable(env_file) == 1 then
    for line in io.lines(env_file) do
      local value = line:match('^NEOVIM_OPENROUTER_API_KEY=(.*)$')
      if value then
        return value:gsub('^["\']', ''):gsub('["\']$', '')
      end
    end
  end

  return nil
end

minuet.setup {
  -- Disable cmp integration - using virtual text instead
  cmp = {
    enable_auto_complete = false,
  },

  -- Virtual text (ghost text) configuration
  virtualtext = {
    auto_trigger_ft = {}, -- Manual trigger only
    keymap = {
      -- All nil - we handle keymaps manually below to avoid hijacking Escape
      accept = nil,
      accept_line = nil,
      accept_n_lines = nil,
      next = nil,
      prev = nil,
      dismiss = nil,
    },
    show_on_completion_menu = false,
  },

  -- Using OpenRouter
  provider = 'openai_compatible',
  provider_options = {
    openai_compatible = {
      api_key = get_api_key,
      end_point = 'https://openrouter.ai/api/v1/chat/completions',
      model = 'google/gemini-2.0-flash-001',
      name = 'Openrouter',
      optional = {
        max_tokens = 256,
        top_p = 0.9,
      },
    },
  },

  -- Settings
  throttle = 200,
  debounce = 200,
  request_timeout = 3,
  notify = 'warn',
}

-- Manual keymaps for virtual text
local vt = require('minuet.virtualtext')

-- Ctrl-y: trigger completion
vim.keymap.set('i', '<C-y>', function()
  vt.action.next()
end, { desc = 'Minuet: trigger completion' })

-- Tab: accept completion if visible, otherwise normal tab
vim.keymap.set('i', '<Tab>', function()
  if vt.action.is_visible() then
    vt.action.accept()
  else
    return '<Tab>'
  end
end, { expr = true, desc = 'Minuet: accept completion or tab' })

-- Ctrl-] / Ctrl-[: cycle through completion options
vim.keymap.set('i', '<C-]>', function()
  vt.action.next()
end, { desc = 'Minuet: next completion' })

vim.keymap.set('i', '<C-[>', function()
  vt.action.prev()
end, { desc = 'Minuet: previous completion' })

-- Auto-dismiss ghost text when leaving insert mode
vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    if vt.action.is_visible() then
      vt.action.dismiss()
    end
  end,
  desc = 'Dismiss Minuet ghost text on InsertLeave',
})

-- Status command
vim.api.nvim_create_user_command('MinuetStatus', function()
  local api_key = get_api_key()
  local msg = ''
  local level = vim.log.levels.INFO

  if api_key and api_key ~= '' then
    msg = 'Minuet AI Status\n\n'
        .. '✓ API key loaded\n'
        .. '✓ Provider: Openrouter\n'
        .. '✓ Model: google/gemini-2.0-flash-001\n'
        .. '\nKeymaps:\n'
        .. '  Ctrl-y  - Trigger AI completion\n'
        .. '  Ctrl-]  - Next completion option\n'
        .. '  Ctrl-[  - Previous completion option\n'
        .. '  Tab     - Accept completion\n'
        .. '  Escape  - Normal mode (auto-dismisses)\n'
        .. '\nCommands:\n'
        .. '  :Minuet virtualtext toggle\n'
        .. '  :Minuet change_model'
  else
    msg = 'Minuet AI Status\n\n'
        .. '✗ API key NOT found\n\n'
        .. 'Add to ~/.config/nvim/.env:\n'
        .. 'NEOVIM_OPENROUTER_API_KEY=your-key-here'
    level = vim.log.levels.ERROR
  end

  vim.notify(msg, level, { title = 'Minuet AI' })
end, { desc = 'Check Minuet AI status' })
