-- mini.ai - Better Around/Inside textobjects
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [']quote
--  - ci'  - [C]hange [I]nside [']quote
--  - dan( - [D]elete [A]round [N]ext [(]paren
--  - vil{ - [V]isually select [I]nside [L]ast [{]brace
require('mini.ai').setup { n_lines = 500 }

-- mini.statusline disabled - using lualine instead
-- See after/plugin/lualine.lua for statusline configuration
