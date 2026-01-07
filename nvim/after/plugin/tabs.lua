if vim.g.vscode then return end

-- Enhanced native tab configuration

-- Enable mouse support for tabs (click to switch, middle-click to close)
vim.opt.mouse = 'a'

-- Show tab numbers and better formatting
vim.opt.showtabline = 2 -- Always show tabline
vim.opt.tabline = '%!v:lua.MyTabLine()'

-- Custom tabline function with scroll to keep active tab visible
function _G.MyTabLine()
  local total_tabs = vim.fn.tabpagenr('$')
  local current_tab = vim.fn.tabpagenr()
  local available_width = vim.o.columns

  -- Helper to get tab label
  local function get_tab_label(i)
    local buflist = vim.fn.tabpagebuflist(i)
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = buflist[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local label = ' ' .. i .. ' '
    if bufname == '' then
      label = label .. '[No Name]'
    else
      label = label .. vim.fn.fnamemodify(bufname, ':t')
    end
    local bufmodified = vim.fn.getbufvar(bufnr, "&modified")
    if bufmodified == 1 then
      label = label .. ' [+]'
    end
    label = label .. ' '
    return label
  end

  -- Calculate width of each tab
  local tab_widths = {}
  local total_width = 0
  for i = 1, total_tabs do
    tab_widths[i] = #get_tab_label(i)
    total_width = total_width + tab_widths[i]
  end

  -- If everything fits, show all tabs
  if total_width <= available_width then
    local s = ''
    for i = 1, total_tabs do
      if i == current_tab then
        s = s .. '%#TabLineSel#'
      else
        s = s .. '%#TabLine#'
      end
      s = s .. '%' .. i .. 'T' .. get_tab_label(i)
    end
    return s .. '%#TabLineFill#%T'
  end

  -- Need to scroll - find range of tabs to show centered on current
  local indicator_width = 4 -- "< " or " >"
  local usable_width = available_width - (indicator_width * 2)

  -- Start with current tab and expand outward
  local start_tab = current_tab
  local end_tab = current_tab
  local used_width = tab_widths[current_tab]

  -- Expand alternating left and right
  local expand_left = true
  while true do
    if expand_left and start_tab > 1 then
      if used_width + tab_widths[start_tab - 1] <= usable_width then
        start_tab = start_tab - 1
        used_width = used_width + tab_widths[start_tab]
      end
    elseif not expand_left and end_tab < total_tabs then
      if used_width + tab_widths[end_tab + 1] <= usable_width then
        end_tab = end_tab + 1
        used_width = used_width + tab_widths[end_tab]
      end
    end

    -- Check if we can expand more
    local can_expand_left = start_tab > 1 and used_width + tab_widths[start_tab - 1] <= usable_width
    local can_expand_right = end_tab < total_tabs and used_width + tab_widths[end_tab + 1] <= usable_width
    if not can_expand_left and not can_expand_right then break end

    expand_left = not expand_left
  end

  -- Build the tabline
  local s = ''

  -- Left indicator
  if start_tab > 1 then
    s = s .. '%#TabLine#< '
  else
    s = s .. '%#TabLineFill#  '
  end

  -- Visible tabs
  for i = start_tab, end_tab do
    if i == current_tab then
      s = s .. '%#TabLineSel#'
    else
      s = s .. '%#TabLine#'
    end
    s = s .. '%' .. i .. 'T' .. get_tab_label(i)
  end

  -- Right indicator
  if end_tab < total_tabs then
    s = s .. '%#TabLine# >'
  end

  return s .. '%#TabLineFill#%T'
end

-- Tab management keybindings

-- Move tabs left/right with Ctrl+Shift+H/L
vim.keymap.set('n', '<C-S-h>', ':-tabmove<CR>', { desc = 'Move tab left', silent = true })
vim.keymap.set('n', '<C-S-l>', ':+tabmove<CR>', { desc = 'Move tab right', silent = true })

-- Ctrl+t opens Telescope file picker in new tab (defined in telescope.lua)

-- Go to specific tab number
for i = 1, 9 do
  vim.keymap.set('n', '<leader>t' .. i, ':tabn ' .. i .. '<CR>', { desc = 'Go to tab ' .. i })
end

-- Move to last tab
vim.keymap.set('n', '<leader>t0', ':tablast<CR>', { desc = 'Go to last tab' })
