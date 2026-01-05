require('lspsaga').setup({
  -- Use default config but with some nice customizations
  ui = {
    -- Border style: "single", "double", "rounded", "solid", "shadow"
    border = "rounded",
    -- Show code action lightbulb
    code_action = '',
  },
  -- Lightbulb
  lightbulb = {
    enable = true,
    sign = true,
    virtual_text = true,  -- Show code action hints inline
  },
  -- Scroll in hover doc and definition preview
  scroll_preview = {
    scroll_down = '<C-f>',
    scroll_up = '<C-b>',
  },
  -- Symbol in winbar (breadcrumbs)
  symbol_in_winbar = {
    enable = false,  -- Disable for now, can enable if you want breadcrumbs
  },
  -- Code action options
  code_action = {
    num_shortcut = true,
    show_server_name = true,
    extend_gitsigns = false,
    keys = {
      quit = { 'q', '<Esc>' },
      exec = '<CR>',
    },
  },
  -- Finder (references, definitions, implementations all in one)
  finder = {
    keys = {
      toggle_or_open = '<CR>',
      vsplit = 'v',
      split = 's',
      tabnew = 't',
      quit = { 'q', '<Esc>' },
    },
  },
  -- Rename
  rename = {
    in_select = true,
    auto_save = false,
    keys = {
      quit = { '<C-c>', '<Esc>' },
      exec = '<CR>',
    },
  },
})
