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

  on_colors = function(c)
    -- Theme colors here https://github.com/lcrownover/tokyonight.nvim/blob/main/lua/tokyonight/colors.lua
    c.hint = c.orange
    c.fg_gutter = "#585f89"
    c.fg_dimmed = "#30364f"
    c.comment = "#5e668d"
  end,
  on_highlights = function(hl, c)
    -- See highlights here https://github.com/lcrownover/tokyonight.nvim/blob/main/lua/tokyonight/theme.lua
    local prompt = "#2d3149"
    -- Modern styling for Telescope
    hl.TelescopeNormal = {
      bg = c.bg_dark,
      fg = c.fg_dark,
    }
    hl.TelescopeBorder = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    hl.TelescopePromptNormal = {
      bg = prompt,
    }
    hl.TelescopePromptBorder = {
      bg = prompt,
      fg = prompt,
    }
    hl.TelescopePromptTitle = {
      bg = prompt,
      fg = prompt,
    }
    hl.TelescopePreviewTitle = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    hl.TelescopeResultsTitle = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    -- Make indent-blankline less apparent https://github.com/lukas-reineke/indent-blankline.nvim/blob/master/lua/ibl/config.lua
    hl.IblIndent = {
      fg = c.fg_dimmed
    }
  end,
})

vim.cmd([[colorscheme tokyonight]])
