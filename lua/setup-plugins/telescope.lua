local actions = require("telescope.actions")

require("telescope").setup({
	-- file_ignore_patterns = { "node_modules", ".git" },
	defaults = {
		layout_config = { height = 0.95, width = 0.95 },
		layout_strategy = "vertical",
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		entry_prefix = "  ",
		prompt_prefix = "> ",
		selection_caret = "> ",
		path_display = { "smart" },
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<CR>"] = actions.select_default,
			},
		},
	},
	-- pickers = {
	-- 	find_files = {
	-- 		theme = "dropdown",
	-- 	},
	-- 	git_files = {
	-- 		theme = "dropdown",
	-- 	},
	-- 	live_grep = {
	-- 		theme = "dropdown",
	-- 	},
	-- 	buffers = {
	-- 		theme = "dropdown",
	-- 	},
	-- 	help_tags = {
	-- 		theme = "dropdown",
	-- 	},
	-- },
	-- extensions = {
	-- 	fzf = {
	-- 		fuzzy = true, -- false will only do exact matching
	-- 		override_generic_sorter = true, -- override the generic sorter
	-- 		override_file_sorter = true, -- override the file sorter
	-- 		case_mode = "smart_case", -- or "ignore_case" or "respect_case"
	-- 	},
	-- },
	-- defaults = {
	--     initial_mode = 'insert',
	--     path_display = {'absolute'},
	--     wrap_results = true,
	--     layout_strategy = 'vertical',
	--     layout_config = {height = 0.95, width = 0.95},
	--     default_mappings = false,
	--     mappings = {
	--         i = {["<C-j>"] = require('telescope.actions').move_selection_next}
	--     }
	-- },
	-- extensions = { }
})

require("telescope").load_extension("node_modules")
require("telescope").load_extension("conflicts")
-- require('telescope').load_extension('telescope-tabs')
-- require("telescope").load_extension("i23")
-- require("telescope").load_extension("import")
-- require('telescope').load_extension('fzf')
-- require('telescope').load_extension('project')
-- require('telescope').load_extension('dap')

-- Function to search node_modules
function SearchNodeModules()
	require("telescope.builtin").find_files({
		prompt_title = "< Search node_modules >",
		cwd = vim.fn.getcwd() .. "/node_modules",
	})
end

local keymap = vim.keymap.set
-- search + LSP
local builtin = require("telescope.builtin")
keymap("n", "<leader>sn", ":Telescope node_modules list<CR>", { noremap = true, silent = true })
keymap(
	"n",
	"<leader>sf",
	":Telescope find_files find_command=rg,--smart-case,--ignore,--hidden,--files<CR>",
	{ noremap = true, silent = true }
)
keymap("n", "<leader>ss", builtin.live_grep, { noremap = true, silent = true })
keymap(
	"n",
	"<leader>sw",
	':lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })<CR>',
	{ noremap = true, silent = true }
)
keymap("n", "<leader>sb", builtin.buffers, { noremap = true, silent = true })
-- keymap('n', '<leader>sm', builtin.marks, {})
-- search and replace current word
keymap("n", "<leader>sr", ":lua require('spectre').open_visual({select_word=true})<CR>", {})

keymap("n", "gd", builtin.lsp_definitions, { noremap = true, silent = true })
keymap("n", "<leader>gk", "<cmd>Lspsaga peek_definition<CR>", { noremap = true, silent = true })
keymap("n", "<leader>gt", builtin.lsp_type_definitions, { noremap = true, silent = true })
keymap("n", "<leader>gr", "<cmd>Lspsaga finder<CR>", { noremap = true, silent = true })
keymap("n", "<leader>gi", builtin.lsp_implementations, { noremap = true, silent = true })
keymap("n", "<leader>gE", "<cmd>Lspsaga show_buf_diagnostics<CR>", { noremap = true, silent = true })
keymap("n", "<leader>ge", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { noremap = true, silent = true })

-- Map the function to a command or keybinding
keymap("n", "<leader>sm", "<cmd>lua SearchNodeModules()<CR>", { noremap = true, silent = true })
