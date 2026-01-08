require('flash').setup({
  -- Labels to use for labeling jump targets
  labels = "asdfghjklqwertyuiopzxcvbnm",

  -- Search configuration
  search = {
    -- Search is case-insensitive by default
    mode = "exact",
    -- Incremental search
    incremental = false,
  },

  -- Jump configuration
  jump = {
    -- Jump on first match
    jumplist = true,
    -- Save location in jumplist
    pos = "start",
    -- Automatically jump when there is only one match
    autojump = false,
  },

  -- Label configuration
  label = {
    -- Allow uppercase labels
    uppercase = true,
    -- Add a label for the first match
    rainbow = {
      enabled = false,
      shade = 5,
    },
  },

  -- Highlight configuration
  highlight = {
    -- Show backdrop
    backdrop = true,
  },

  -- Modes configuration
  modes = {
    -- Enhanced f/F/t/T with jump labels
    -- Clever-f style: repeat f with f, F goes backward (frees ; for treesitter)
    char = {
      enabled = true,
      jump_labels = true,
      multi_line = true,
      keys = { "f", "F", "t", "T" },  -- no ; and , (let treesitter have them)
      char_actions = function(motion)
        return {
          [motion:lower()] = "next",
          [motion:upper()] = "prev",
        }
      end,
      jump = { autojump = true },  -- auto-jump when only one match
      highlight = { backdrop = true },
    },
    -- Options for search - DISABLED so Flash doesn't hijack / search
    search = {
      enabled = false,
    },
    -- Options for treesitter
    treesitter = {
      labels = "abcdefghijklmnopqrstuvwxyz",
      jump = { pos = "range" },
      highlight = {
        backdrop = false,
        matches = false,
      },
    },
  },
})

-- Keymaps
vim.keymap.set({ 'n', 'x', 'o' }, 'gs', function()
  require('flash').jump({
    jump = {
      register = true,  -- add to search register (for n/N)
      history = true,   -- add to search history
    },
  })
end, { desc = 'Flash jump search (n/N to repeat)' })

vim.keymap.set({ 'n', 'x', 'o' }, 'gS', function()
  require('flash').treesitter()
end, { desc = 'Flash treesitter select' })
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Flash remote operation' })
vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end,
  { desc = 'Flash treesitter search (visual)' })
vim.keymap.set('c', '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash in command mode' })
