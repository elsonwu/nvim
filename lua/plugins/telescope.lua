return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	lazy = true,
	dependencies = {
		"nvim-lua/popup.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"piersolenski/telescope-import.nvim",
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

		require("telescope").setup({
			pickers = {
				find_files = {
					theme = "ivy",
				},
			},
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					-- "--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					-- "--fixed-string",
				},
				layout_config = { height = 0.95, width = 0.95 },
				layout_strategy = "vertical",
				path_display = { "absolute" },
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<CR>"] = actions.select_default,
						["<C-q>"] = send_to_qflist,
					},
					n = {
						["<C-q>"] = send_to_qflist,
					},
				},
				set_env = { COLORTERM = "truecolor" }, -- default = nil,
			},
		})

		-- require("telescope").load_extension("fzf")
		require("telescope").load_extension("file_browser")
	end,
}
