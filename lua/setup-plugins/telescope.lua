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
	defaults = {
		find_command = {"rg", "--files", "--hidden", "-g", "!.git"},
		layout_config = { height = 0.95, width = 0.95 },
		layout_strategy = "vertical",
		entry_prefix = "  ",
		prompt_prefix = "> ",
		selection_caret = "> ",
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
		-- border = {},
		borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		color_devicons = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
	},
})

require("telescope").load_extension("node_modules")
require("telescope").load_extension("fzf")
