-- mini.ai - Better Around/Inside textobjects
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [']quote
--  - ci'  - [C]hange [I]nside [']quote
--  - dan( - [D]elete [A]round [N]ext [(]paren
--  - vil{ - [V]isually select [I]nside [L]ast [{]brace
require('mini.ai').setup { n_lines = 500 }

-- mini.surround - Add/delete/replace surroundings (brackets, quotes, etc.)
-- Examples:
--  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
--  - saiw" - [S]urround [A]dd [I]nner [W]ord ["]quotes
--  - sd'   - [S]urround [D]elete [']quotes
--  - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

-- Make 's' wait for next key (like 'g' does) and show which-key hints
vim.keymap.set('n', 's', function()
  -- Show which-key popup for 's' mappings
  local wk_ok, wk = pcall(require, 'which-key')
  if wk_ok then
    wk.show({ keys = 's', mode = 'n', loop = true })
  end
end, { desc = '+surround' })

-- mini.statusline disabled - using lualine instead
-- See after/plugin/lualine.lua for statusline configuration
