require("nvim-treesitter.configs").setup({
	-- ensure_installed = 'all',
	sync_install = false,
	-- auto_install = true,
	autotag = { enable = true },
	indent = {
		enable = true,
		disable = { "yaml" },
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

vim.cmd("autocmd BufNewFile,BufRead *.avdl setfiletype java")
