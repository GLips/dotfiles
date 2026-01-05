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

  -- Set buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, all_lists)

  -- Calculate window size and position
  local width = 40
  local height = #all_lists
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

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

  -- Enter to select
  vim.keymap.set('n', '<CR>', select_list, { buffer = buf, nowait = true })
  vim.keymap.set('n', '<Esc>', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })
  vim.keymap.set('n', '<C-e>', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })
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

