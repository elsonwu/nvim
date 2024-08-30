return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	lazy = true,
	dependencies = {
		"nvim-lua/popup.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"piersolenski/telescope-import.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
	},
	config = function()
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		local function send_to_qflist(prompt_bufnr)
			local picker = action_state.get_current_picker(prompt_bufnr)
			local multi_selection = picker:get_multi_selection()

			for _, entry in ipairs(multi_selection) do
				vim.fn.setqflist({}, "a", {
					title = "Telescope Results",
					items = {
						{
							filename = entry.path or entry.filename,
							lnum = entry.lnum,
							col = entry.col,
							text = entry.text,
						},
					},
				})
			end
			vim.cmd("copen")
			actions.close(prompt_bufnr)
		end

		local lga_actions = require("telescope-live-grep-args.actions")

		require("telescope").setup({
			defaults = {
				layout_config = { height = 0.95, width = 0.95 },
				layout_strategy = "vertical",
				prompt_prefix = "🔍 ",
				selection_caret = "➜ ",
				entry_prefix = "  ",
				path_display = { "absolute" },
				color_devicons = true,
				set_env = { COLORTERM = "truecolor" }, -- default = nil,
				border = {},
				borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				mappings = {
					i = {
						["<C-o>"] = function(p_bufnr)
							require("telescope.actions").send_selected_to_qflist(p_bufnr)
							vim.cmd.cfdo("edit")
						end,
						["<esc>"] = actions.close,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<CR>"] = actions.select_default,
						["<C-q>"] = send_to_qflist,
					},
					n = {
						["<C-q>"] = send_to_qflist,
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
			},
		})

		require("telescope").load_extension("fzf")
		require("telescope").load_extension("live_grep_args")
	end,
}
