if vim.g.vscode then return end

local telescope = require('telescope.builtin')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- Function to check if a file is open in any tab and switch to it
local function switch_to_file_if_open(filepath)
  -- Normalize the filepath
  local target_path = vim.fn.fnamemodify(filepath, ':p')

  -- Search through all tabs
  for tabnr = 1, vim.fn.tabpagenr('$') do
    -- Get all buffers in this tab
    local buffers = vim.fn.tabpagebuflist(tabnr)
    for _, bufnr in ipairs(buffers) do
      local bufpath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p')
      if bufpath == target_path then
        -- Found it! Switch to this tab
        vim.cmd('tabn ' .. tabnr)
        -- Find the window with this buffer in the tab
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
          if vim.api.nvim_win_get_buf(win) == bufnr then
            vim.api.nvim_set_current_win(win)
            return true
          end
        end
      end
    end
  end
  return false
end

-- Custom Ctrl+P that combines buffers and files, prioritizing open files
local function ctrl_p()
  -- Get list of open buffer files
  local open_files = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local filepath = vim.api.nvim_buf_get_name(buf)
      if filepath and filepath ~= '' then
        open_files[vim.fn.fnamemodify(filepath, ':p')] = true
      end
    end
  end

  -- First show buffers, then all files
  require('telescope.pickers').new({}, {
    prompt_title = 'Find Files',
    finder = require('telescope.finders').new_oneshot_job(
      vim.tbl_flatten({
        'fd',
        '--type', 'f',
        '--hidden',
        '--follow',
        '--exclude', '.git',
      }),
      {}
    ),
    sorter = require('telescope.config').values.file_sorter({}),
    previewer = require('telescope.config').values.file_previewer({}),
    attach_mappings = function(prompt_bufnr, map)
      -- Alt+Backspace to delete word
      map('i', '<M-BS>', function() vim.api.nvim_input("<C-w>") end)
      
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection then
          local filepath = selection[1] or selection.value

          -- Try to switch to existing tab first
          if not switch_to_file_if_open(filepath) then
            -- File not open, open it normally
            vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
          end
        end
      end)

      return true
    end,
  }):find()
end

-- Map Ctrl+P to our custom finder
vim.keymap.set('n', '<C-p>', ctrl_p, { desc = 'Find files (prioritize open)' })
