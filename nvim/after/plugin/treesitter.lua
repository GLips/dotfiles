require('nvim-treesitter.configs').setup {
	-- Install parsers for these languages
	ensure_installed = {
		"javascript",
		"typescript",
		"tsx",        -- TypeScript JSX
		"lua",
		"rust",
		"c",
		"json",
		"markdown",
		"html",
		"css"
	},

	-- Install parsers synchronously
	sync_install = false,

	-- Auto-install missing parsers when entering buffer
	auto_install = true,

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},

	-- Text objects for functions, classes, parameters, etc.
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj

			keymaps = {
				-- Functions
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				-- Classes
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				-- Parameters/arguments
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				-- Conditionals (if/else)
				["ai"] = "@conditional.outer",
				["ii"] = "@conditional.inner",
				-- Loops
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
			},

			selection_modes = {
				['@parameter.outer'] = 'v', -- charwise
				['@function.outer'] = 'V', -- linewise
				['@class.outer'] = 'V', -- linewise
			},
		},

		-- Move between functions, classes, etc.
		move = {
			enable = true,
			set_jumps = true, -- Set jumps in jumplist

			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
				["]a"] = "@parameter.inner",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
				["[a"] = "@parameter.inner",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
}

-- Repeatable move: ; and , repeat any movement
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- Make ; repeat forward and , repeat backward
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- Make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
