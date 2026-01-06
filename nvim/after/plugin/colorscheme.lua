if vim.g.vscode then return end

require("tokyonight").setup({
  style = "night", -- storm, moon, night, or day
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
  },
  sidebars = { "qf", "help", "neo-tree" },
  day_brightness = 0.3,
  hide_inactive_statusline = false,
  dim_inactive = false,
  lualine_bold = false,

  on_colors = function(colors) end,
  on_highlights = function(highlights, colors) end,
})

vim.cmd([[colorscheme tokyonight]])
