vim.api.nvim_set_keymap("c", "<C-k>", "<Up>", {})
vim.api.nvim_set_keymap("c", "<C-j>", "<Down>", {})
vim.api.nvim_set_keymap("c", "<C-h>", "<Left>", {})
vim.api.nvim_set_keymap("c", "<C-l>", "<Right>", {})

vim.api.nvim_set_keymap("i", "<C-k>", "<Up>", {})
vim.api.nvim_set_keymap("i", "<C-j>", "<Down>", {})
vim.api.nvim_set_keymap("i", "<C-h>", "<Left>", {})
vim.api.nvim_set_keymap("i", "<C-l>", "<Right>", {})

local keymap = vim.keymap.set

-- basic
keymap("n", "<leader>ww", ":bdelete<CR>", { silent = true })
keymap("n", "<leader>wh", ":NvimTreeToggle<CR>", { silent = true })
keymap("n", "<leader>ff", ":NvimTreeFindFileToggle<CR>", { silent = true })
keymap("n", "<leader>F", ":NvimTreeFindFile<CR>", { silent = true })
keymap("n", "<C-n>", ":bnext<CR>", { silent = true })
keymap("n", "<C-p>", ":bprev<CR>", { silent = true })
keymap("x", "<", "<gv", { noremap = true, silent = true })
keymap("x", ">", ">gv", { noremap = true, silent = true })

-- search & replace
keymap("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre",
})

-- format
keymap(
	"n",
	"<leader>fmt",
	':lua require("conform").format({ async = true, lsp_format = "fallback" })<CR>',
	{ noremap = true, silent = true }
)

-- LSP
keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { noremap = true, silent = true })
keymap("n", "<leader>h", "<cmd>Lspsaga peek_definition<CR>", { noremap = true, silent = true })
keymap("n", "<leader>T", "<cmd>Lspsaga peek_type_definition<CR>", { noremap = true, silent = true })
keymap({ "n", "v" }, "<leader>ga", "<cmd>Lspsaga code_action<CR>", { noremap = true, silent = true })

-- switch project
keymap("n", "<leader>lw", ":lua require'telescope'.extensions.project.project{}<CR>", { noremap = true, silent = true })

-- Diagnostic jump can use `<c-o>` to jump back
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { noremap = true, silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { noremap = true, silent = true })

-- DAP debugger
keymap("n", "<leader>dc", ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
keymap("n", "<leader>d_", ":lua require'dap'.run_to_cursor()<CR>", { noremap = true, silent = true })
keymap("n", "<leader>do", ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
keymap("n", "<leader>dO", ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
keymap("n", "<leader>di", ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
keymap("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
keymap("n", "<leader>dd", ":lua require'dap'.repl.open()<CR>", { noremap = true, silent = true })
keymap("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", { noremap = true, silent = true })

-- Git
keymap("n", "<leader>bb", ":Gitsigns blame_line<CR>", { noremap = true, silent = true })
keymap("n", "]x", "<Plug>(git-conflict-prev-conflict)")
keymap("n", "[x", "<Plug>(git-conflict-next-conflict)")

-- Highlight selected
keymap("v", "<leader>hl", ":<c-u>HSHighlight<CR>", { noremap = true, silent = true })
keymap("n", "<leader>hr", ":HSRmHighlight rm_all<CR>", { noremap = true, silent = true })

-- Terminal
keymap("n", "<leader>tt", ":ToggleTerm<CR>", { noremap = true, silent = true })

-- Copilet
keymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
