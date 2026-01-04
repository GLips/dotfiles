require('error-lens').setup({
  enabled = true,
  auto_adjust = {
    enable = true,
    fallback_bg_color = "#1e1e1e", -- Fallback background color if auto-adjust fails
    step = 7, -- Increment/decrement step for background color adjustment
  },
  prefix = 4, -- Space between end of line and error message
  -- Colors for different diagnostic severities
  colors = {
    error_fg = "#FF6C6B",
    error_bg = "#51202A",
    warn_fg = "#DFAF00",
    warn_bg = "#38300C",
    info_fg = "#4FC1FF",
    info_bg = "#0E3448",
    hint_fg = "#4FC1FF",
    hint_bg = "#0E3448",
  },
})
