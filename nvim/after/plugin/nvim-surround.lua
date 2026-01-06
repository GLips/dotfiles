-- nvim-surround - Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- Default mappings:
--  Normal mode:
--    - ys{motion}{char}  - Add surround (e.g., ysiw" to surround word with quotes)
--    - cs{old}{new}      - Change surround (e.g., cs"' to change " to ')
--    - ds{char}          - Delete surround (e.g., ds" to delete quotes)
--  Visual mode:
--    - S{char}           - Surround selection with char
--
-- Custom mappings added below (normal and visual):
--    - <leader>sd{char}     - Delete surrounding char
--    - <leader>sc{old}{new} - Change surrounding char

require('nvim-surround').setup({
  keymaps = {
    insert = "<C-g>s",
    insert_line = "<C-g>S",
    normal = "ys",
    normal_cur = "yss",
    normal_line = "yS",
    normal_cur_line = "ySS",
    visual = "S",
    visual_line = "gS",
    delete = "ds",
    change = "cs",
    change_line = "cS",
  },
})

-- Register <leader>s group with which-key for both normal and visual modes
local wk_ok, wk = pcall(require, 'which-key')
if wk_ok then
  wk.add({
    { "<leader>s", group = "surround", mode = { "n", "v" } },
    { "<leader>sd", desc = "Delete surround", mode = { "n", "v" } },
    { "<leader>sc", desc = "Change surround", mode = { "n", "v" } },
  })
end

-- <leader>sd - Delete surrounding (then type the character to delete)
-- Works in both normal and visual mode
vim.keymap.set({ 'n', 'x' }, '<leader>sd', function()
  -- If in visual mode, exit first
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '\22' then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
  end
  -- Feed the delete surround command - nvim-surround will wait for the character
  vim.api.nvim_feedkeys('ds', 'm', false)
end, { desc = 'Delete surround' })

-- <leader>sc - Change surrounding (then type old char, then new char)
-- Works in both normal and visual mode
vim.keymap.set({ 'n', 'x' }, '<leader>sc', function()
  -- If in visual mode, exit first
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '\22' then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
  end
  -- Feed the change surround command - nvim-surround will wait for old and new characters
  vim.api.nvim_feedkeys('cs', 'm', false)
end, { desc = 'Change surround' })
