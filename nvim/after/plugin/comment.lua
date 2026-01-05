require('Comment').setup()

-- VSCode-style Ctrl+/ to toggle line comments
-- Note: In terminals, Ctrl+/ is sent as Ctrl+_ due to terminal limitations
vim.keymap.set('n', '<C-_>', function()
  return vim.api.nvim_get_vvar('count') == 0
    and '<Plug>(comment_toggle_linewise_current)'
    or '<Plug>(comment_toggle_linewise_count)'
end, { expr = true, desc = 'Toggle comment' })

vim.keymap.set('v', '<C-_>', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Toggle comment' })
