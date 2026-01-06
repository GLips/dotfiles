if vim.g.vscode then return end

-- Show the current context (function, class, etc.) at the top of the screen
local status_ok, treesitter_context = pcall(require, 'treesitter-context')
if not status_ok then
  return
end

treesitter_context.setup {
  enable = true,
  max_lines = 3, -- How many lines the context window should span
  min_window_height = 0, -- Minimum editor window height to enable context
  line_numbers = true,
  multiline_threshold = 1, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if max_lines is exceeded
  mode = 'cursor', -- Line used to calculate context. 'cursor' or 'topline'
  separator = nil, -- Separator between context and content. nil uses treesitter highlight
  zindex = 20, -- The Z-index of the context window
}

-- Keybinding to jump to context (go to the function/class definition)
vim.keymap.set('n', 'gC', function()
  treesitter_context.go_to_context(vim.v.count1)
end, { silent = true, desc = 'Jump to context' })
