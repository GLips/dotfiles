-- Safely load treesitter config
local status_ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  vim.notify('nvim-treesitter.configs not found. Run :TSUpdate', vim.log.levels.WARN)
  return
end

treesitter_configs.setup {
	-- Install parsers for these languages
	ensure_installed = {
		"javascript",
		"typescript",
		"tsx",        -- TypeScript JSX
		"jsx",        -- JavaScript JSX
		"lua",
		"rust",
		"c",
		"json",
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
}
