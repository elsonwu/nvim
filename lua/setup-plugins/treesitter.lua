require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	auto_install = true,
	autotag = { enable = true },
	indent = {
		enable = true,
		-- disable = { "yaml" },
	},
	sync_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

vim.cmd("autocmd BufNewFile,BufRead *.avdl setfiletype java")
