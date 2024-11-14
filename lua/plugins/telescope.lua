return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	lazy = true,
	dependencies = {
		"nvim-lua/popup.nvim",
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
	},
	config = function()
		local actions = require("telescope.actions")

		require("telescope").setup({
			defaults = {
				layout_config = { height = 0.95, width = 0.95 },
				layout_strategy = "vertical",
				prompt_prefix = "🔍 ",
				selection_caret = "➜ ",
				entry_prefix = "  ",
				path_display = { "filename_first" },
				color_devicons = true,
				set_env = { COLORTERM = "truecolor" }, -- default = nil,
				border = {},
				borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				mappings = {
					i = {
						["<C-n>"] = function()
							vim.cmd("stopinsert")
						end, -- Switch to normal mode
						["<C-o>"] = function(p_bufnr)
							require("telescope.actions").send_selected_to_qflist(p_bufnr)
							vim.cmd.cfdo("edit")
						end,
						["<esc>"] = actions.close,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<CR>"] = actions.select_default,
					},
					n = {
						["<C-i>"] = function()
							vim.cmd("startinsert")
						end, -- Switch to insert mode
						["<C-o>"] = function(p_bufnr)
							require("telescope.actions").send_selected_to_qflist(p_bufnr)
							vim.cmd.cfdo("edit")
						end,
					},
				},
			},
			extensions = {
				live_grep_args = {
					auto_quoting = true, -- enable/disable auto-quoting
				},
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
			},
		})

		require("telescope").load_extension("fzf")
		require("telescope").load_extension("live_grep_args")
	end,
}
