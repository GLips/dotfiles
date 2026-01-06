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
    -- Options for character search
    char = {
      enabled = true,
      -- Show jump labels
      jump_labels = true,
      -- Multi-line character search
      multi_line = true,
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
vim.keymap.set({ 'n', 'x', 'o' }, 'gs', function() require('flash').jump() end, { desc = 'Flash jump search' })
vim.keymap.set({ 'n', 'x', 'o' }, 'gS', function() 
  require('flash').treesitter({
    -- Add keybindings to expand/contract while in treesitter mode
    actions = {
      [';'] = 'next',  -- expand to parent
      [','] = 'prev',  -- contract to child
    }
  })
end, { desc = 'Flash treesitter (use ; to expand, , to contract)' })
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Flash remote operation' })
vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end,
  { desc = 'Flash treesitter search (visual)' })
vim.keymap.set('c', '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash in command mode' })
