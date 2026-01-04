-- Enhanced native tab configuration

-- Enable mouse support for tabs (click to switch, middle-click to close)
vim.opt.mouse = 'a'

-- Show tab numbers and better formatting
vim.opt.showtabline = 2  -- Always show tabline
vim.opt.tabline = '%!v:lua.MyTabLine()'

-- Custom tabline function
function _G.MyTabLine()
  local s = ''
  for i = 1, vim.fn.tabpagenr('$') do
    -- Select the highlighting
    if i == vim.fn.tabpagenr() then
      s = s .. '%#TabLineSel#'
    else
      s = s .. '%#TabLine#'
    end

    -- Set the tab page number (for mouse clicks)
    s = s .. '%' .. i .. 'T'

    -- Tab number
    s = s .. ' ' .. i .. ' '

    -- Get the buffer name
    local buflist = vim.fn.tabpagebuflist(i)
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = buflist[winnr]
    local bufname = vim.fn.bufname(bufnr)

    -- Format the filename
    if bufname == '' then
      s = s .. '[No Name]'
    else
      s = s .. vim.fn.fnamemodify(bufname, ':t')  -- Just filename, no path
    end

    -- Modified flag
    local bufmodified = vim.fn.getbufvar(bufnr, "&modified")
    if bufmodified == 1 then
      s = s .. ' [+]'
    end

    s = s .. ' '
  end

  -- After the last tab fill with TabLineFill and reset tab page nr
  s = s .. '%#TabLineFill#%T'

  return s
end

-- Tab management keybindings

-- Move tabs left/right with Ctrl+Shift+H/L
vim.keymap.set('n', '<C-S-h>', ':-tabmove<CR>', { desc = 'Move tab left', silent = true })
vim.keymap.set('n', '<C-S-l>', ':+tabmove<CR>', { desc = 'Move tab right', silent = true })

-- New tab
vim.keymap.set('n', '<C-t>', ':tabnew<CR>', { desc = 'New tab' })

-- Go to specific tab number
for i = 1, 9 do
  vim.keymap.set('n', '<leader>t' .. i, ':tabn ' .. i .. '<CR>', { desc = 'Go to tab ' .. i })
end

-- Move to last tab
vim.keymap.set('n', '<leader>t0', ':tablast<CR>', { desc = 'Go to last tab' })

-- List all tabs
vim.keymap.set('n', '<leader>tl', ':tabs<CR>', { desc = 'List tabs' })
