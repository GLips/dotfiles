-- Lualine - Statusline
local status_ok, lualine = pcall(require, 'lualine')
if not status_ok then
  return
end

-- Custom OpenCode component with text instead of just icon
local opencode_component = {
  function()
    local ok, opencode = pcall(require, 'opencode')
    if not ok then
      return ''
    end
    
    local status = opencode.statusline()
    if not status or status == '' then
      return ''
    end
    
    -- If it's just the "not connected" icon, show text instead
    if status == '󱚧' then
      return 'OC'  -- Short for OpenCode
    end
    
    -- Otherwise show the status (probably has useful info when active)
    return status
  end,
  color = { fg = '#7aa2f7' },  -- Nice blue color
}

-- Minuet AI component
local minuet_component = {
  require('minuet.lualine'),
  -- Configuration options for minuet lualine component
  display_name = 'both',  -- Show both provider and model name
  provider_model_separator = ':',
  display_on_idle = false,  -- Don't show when not requesting
}

lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',  -- Match your colorscheme
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,  -- Single statusline for all windows
    refresh = {
      statusline = 100,  -- Refresh every 100ms for smooth spinner
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 
      {
        'filename',
        path = 1,  -- 0 = just filename, 1 = relative path, 2 = absolute path
        symbols = {
          modified = '[+]',
          readonly = '[RO]',
          unnamed = '[No Name]',
        }
      }
    },
    lualine_x = {
      minuet_component,  -- Minuet AI status
      opencode_component,  -- OpenCode status
      'encoding',
      'fileformat',
      'filetype'
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { 'neo-tree', 'trouble', 'quickfix' }
}
