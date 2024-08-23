return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	lazy = true,
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			-- Use a sub-list to run only the first available formatter
			javascript = { { "prettierd", "prettier" } },
			typescript = { { "prettierd", "prettier" } },
			json = { { "prettierd", "prettier" } },
			go = { { "goimports" } },
			rust = { { "rustfmt" } },
			yaml = { { "yamlfmt" } },
		},
	},
}
