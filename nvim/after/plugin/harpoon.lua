if vim.g.vscode then return end

local harpoon = require("harpoon")

-- Setup harpoon2 with custom lists
harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
})

-- Track the currently active list
local active_list = nil  -- nil means default list

-- Helper to get active list
local function get_active_list()
  if active_list then
    return harpoon:list(active_list)
  else
    return harpoon:list()
  end
end

-- Add current file to active harpoon list
vim.keymap.set("n", "<leader>a", function()
  local list = get_active_list()
  list:add()
  local list_name = active_list or "default"
  print("Added to " .. list_name)
end, { desc = "Harpoon: Add file to active list" })

-- Toggle harpoon quick menu (opens active list)
vim.keymap.set("n", "<C-e>", function()
  local list = get_active_list()
  harpoon.ui:toggle_quick_menu(list)
end, { desc = "Harpoon: Toggle active list" })

-- Navigate to harpoon marks
local function safe_select(index)
  local list = get_active_list()
  if list and list.items and #list.items >= index then
    list:select(index)
  else
    vim.notify("Harpoon: No file at position " .. index, vim.log.levels.WARN)
  end
end

vim.keymap.set("n", "<C-1>", function() safe_select(1) end, { desc = "Harpoon: Go to file 1" })
vim.keymap.set("n", "<C-2>", function() safe_select(2) end, { desc = "Harpoon: Go to file 2" })
vim.keymap.set("n", "<C-3>", function() safe_select(3) end, { desc = "Harpoon: Go to file 3" })
vim.keymap.set("n", "<C-4>", function() safe_select(4) end, { desc = "Harpoon: Go to file 4" })

-- Alternative: Navigate with leader + number
vim.keymap.set("n", "<leader>1", function() safe_select(1) end, { desc = "Harpoon: Go to file 1" })
vim.keymap.set("n", "<leader>2", function() safe_select(2) end, { desc = "Harpoon: Go to file 2" })
vim.keymap.set("n", "<leader>3", function() safe_select(3) end, { desc = "Harpoon: Go to file 3" })
vim.keymap.set("n", "<leader>4", function() safe_select(4) end, { desc = "Harpoon: Go to file 4" })

-- Navigate to next/previous harpoon mark
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Harpoon: Previous file" })
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Harpoon: Next file" })

-- Fun, memorable list names
local list_names = {
  "alpha",
  "bravo",
  "charlie",
  "delta",
  "echo",
  "foxtrot",
  "golf",
  "hotel",
}

-- Function to show list selector in a floating window
local function show_list_selector()
  local all_lists = {"default"}
  vim.list_extend(all_lists, list_names)

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Calculate window size first
  local width = 35
  local height = #all_lists
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Build display lines with numbering and item counts
  local display_lines = {}
  local current_active = active_list or "default"
  local highlight_lines = {}
  
  for i, list_name in ipairs(all_lists) do
    -- Get the list and count items properly
    local list
    if list_name == "default" then
      list = harpoon:list()
    else
      list = harpoon:list(list_name)
    end
    
    local item_count = 0
    if list and list.items then
      item_count = #list.items
    end
    
    local is_active = (list_name == current_active)
    
    -- Build the line with proper spacing
    local prefix
    if is_active then
      prefix = string.format("%d. * ", i)
    else
      prefix = string.format("%d.   ", i)
    end
    
    local count_str = string.format("(%d)", item_count)
    -- Calculate available space for list name
    -- width - 4 (border padding) - prefix length - count length - 1 space before count
    local name_width = width - 4 - #prefix - #count_str - 1
    local name_padded = string.format("%-" .. name_width .. "s", list_name)
    
    local line = "  " .. prefix .. name_padded .. " " .. count_str
    
    if is_active then
      table.insert(highlight_lines, i - 1)
    end
    
    table.insert(display_lines, line)
  end

  -- Set buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, display_lines)

  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Harpoon Lists ',
    title_pos = 'center',
  })

  -- Set buffer options
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'

  -- Add highlighting for active list
  local ns_id = vim.api.nvim_create_namespace('harpoon_list_selector')
  for _, line_idx in ipairs(highlight_lines) do
    -- Highlight the entire line
    vim.api.nvim_buf_add_highlight(buf, ns_id, 'CursorLine', line_idx, 0, -1)
    -- Make the asterisk stand out with a special color
    vim.api.nvim_buf_add_highlight(buf, ns_id, 'DiagnosticOk', line_idx, 6, 7)
  end
  
  -- Preview window (declare before autocmd so it can be accessed)
  local preview_win = nil
  local preview_buf = nil
  
  local function show_preview()
    local line = vim.fn.line('.')
    local list_name = all_lists[line]
    
    if not list_name then return end
    
    -- Get the list items
    local list
    if list_name == "default" then
      list = harpoon:list()
    else
      list = harpoon:list(list_name)
    end
    
    local preview_lines = {}
    if list and list.items and #list.items > 0 then
      for i, item in ipairs(list.items) do
        -- Show filename only (not full path)
        local filename = vim.fn.fnamemodify(item.value, ':t')
        table.insert(preview_lines, string.format("  %d. %s", i, filename))
      end
    else
      table.insert(preview_lines, "  (empty)")
    end
    
    -- Create or update preview buffer
    if not preview_buf or not vim.api.nvim_buf_is_valid(preview_buf) then
      preview_buf = vim.api.nvim_create_buf(false, true)
      vim.bo[preview_buf].bufhidden = 'wipe'
    end
    
    -- Make buffer modifiable, update content, then make it unmodifiable again
    vim.bo[preview_buf].modifiable = true
    vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, preview_lines)
    vim.bo[preview_buf].modifiable = false
    
    -- Calculate preview window position (to the right of selector)
    local preview_width = 40
    local preview_height = math.max(#preview_lines, 3)
    local preview_row = row
    local preview_col = col + width + 2
    
    -- Create or update preview window
    if not preview_win or not vim.api.nvim_win_is_valid(preview_win) then
      preview_win = vim.api.nvim_open_win(preview_buf, false, {
        relative = 'editor',
        width = preview_width,
        height = preview_height,
        row = preview_row,
        col = preview_col,
        style = 'minimal',
        border = 'rounded',
        title = ' Files ',
        title_pos = 'center',
      })
    else
      vim.api.nvim_win_set_config(preview_win, {
        relative = 'editor',
        width = preview_width,
        height = preview_height,
        row = preview_row,
        col = preview_col,
      })
    end
  end
  
  -- Show initial preview
  show_preview()
  
  -- Update preview on cursor move
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = buf,
    callback = function()
      show_preview()
    end,
  })
  
  -- Auto-close both windows when main window loses focus
  vim.api.nvim_create_autocmd({"WinLeave", "BufLeave"}, {
    buffer = buf,
    callback = function()
      -- Small delay to ensure window navigation has completed
      vim.schedule(function()
        -- Check if we've navigated away from the selector window
        if vim.api.nvim_get_current_win() ~= win and vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
        -- Always try to close preview window when selector closes
        if preview_win and vim.api.nvim_win_is_valid(preview_win) then
          vim.api.nvim_win_close(preview_win, true)
        end
      end)
    end,
  })

  -- Keymaps for the selector window
  local function select_list()
    local line = vim.fn.line('.')
    local choice = all_lists[line]

    -- Close the window
    vim.api.nvim_win_close(win, true)

    if choice then
      -- Set as active list
      if choice == "default" then
        active_list = nil
      else
        active_list = choice
      end

      -- Open the list
      local list = get_active_list()
      harpoon.ui:toggle_quick_menu(list)

      print("Active list: " .. (active_list or "default"))
    end
  end

  -- Helper to close both windows
  local function close_windows()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if preview_win and vim.api.nvim_win_is_valid(preview_win) then
      vim.api.nvim_win_close(preview_win, true)
    end
  end
  
  -- Enter to select
  vim.keymap.set('n', '<CR>', select_list, { buffer = buf, nowait = true })
  vim.keymap.set('n', '<Esc>', close_windows, { buffer = buf, nowait = true })
  vim.keymap.set('n', 'q', close_windows, { buffer = buf, nowait = true })
  vim.keymap.set('n', '<C-e>', close_windows, { buffer = buf, nowait = true })
  
  -- Allow number keys to quickly select
  for i = 1, #all_lists do
    vim.keymap.set('n', tostring(i), function()
      local choice = all_lists[i]
      close_windows()
      
      if choice then
        if choice == "default" then
          active_list = nil
        else
          active_list = choice
        end
        
        local list = get_active_list()
        harpoon.ui:toggle_quick_menu(list)
        print("Active list: " .. (active_list or "default"))
      end
    end, { buffer = buf, nowait = true })
  end
end

-- Keybinding to show list selector
vim.keymap.set("n", "<leader>hl", show_list_selector, { desc = "Harpoon: Choose and set active list" })

-- Quick add to specific lists
for i, name in ipairs(list_names) do
  if i <= 8 then  -- Only first 8 lists get number keybindings
    vim.keymap.set("n", "<leader>a" .. i, function()
      harpoon:list(name):add()
      print("Added to " .. name)
    end, { desc = "Harpoon: Add to " .. name })
  end
end

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

-- Extension to add Ctrl+E in file picker to open list selector
harpoon:extend({
  UI_CREATE = function(cx)
    vim.keymap.set("n", "<C-e>", function()
      vim.cmd('quit')
      show_list_selector()
    end, { buffer = cx.bufnr })

    vim.keymap.set("n", "t", function()
      local line = vim.fn.line('.')
      local list = get_active_list()

      -- Safety check: make sure list has items
      if not list or not list.items or #list.items == 0 then
        vim.cmd('quit')
        vim.notify("Harpoon list is empty", vim.log.levels.WARN)
        return
      end

      vim.cmd('quit')

      local item = list.items[line]
      if item and item.value then
        vim.cmd('tabedit ' .. vim.fn.fnameescape(item.value))
      end
    end, { buffer = cx.bufnr })
  end,
})


-- Alternative: Telescope picker for Harpoon (faster searching)
vim.keymap.set("n", "<leader>hh", function()
  toggle_telescope(get_active_list())
end, { desc = "Harpoon: Telescope picker" })

local harpoon_extensions = require("harpoon.extensions")
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

