return {
	"glepnir/lspsaga.nvim",
	branch = "main",
	-- event = "VeryLazy",
	dependencies = {
		{ "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
	},
	opts = {
		request_timeout = 5000,
	},
}
