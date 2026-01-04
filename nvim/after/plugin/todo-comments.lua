-- Highlight and search TODO, FIXME, NOTE, etc. comments
local status_ok, todo_comments = pcall(require, 'todo-comments')
if not status_ok then
  return
end

todo_comments.setup {
  signs = false, -- Don't show signs in the gutter
  keywords = {
    FIX = {
      icon = " ", -- Icon used for the sign, and in search results
      color = "error", -- Can be a hex color, or a named color
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- Alternate keywords
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  highlight = {
    multiline = true, -- Enable multiline todo comments
    before = "", -- "fg" or "bg" or empty
    keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty
    after = "fg", -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- Pattern used for highlighting
    comments_only = true, -- Uses treesitter to match keywords in comments only
    max_line_len = 400, -- Ignore lines longer than this
    exclude = {}, -- List of file types to exclude highlighting
  },
}

-- Keybindings
vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })

vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })

-- Search through all project todos with Telescope
vim.keymap.set('n', '<leader>st', ':TodoTelescope<CR>', { desc = 'Search todos' })

-- Open todos in quickfix list
vim.keymap.set('n', '<leader>qt', ':TodoQuickFix<CR>', { desc = 'Todos in quickfix' })
