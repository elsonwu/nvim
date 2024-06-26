vim.api.nvim_set_keymap("c", "<C-k>", "<Up>", {})
vim.api.nvim_set_keymap("c", "<C-j>", "<Down>", {})
vim.api.nvim_set_keymap("c", "<C-h>", "<Left>", {})
vim.api.nvim_set_keymap("c", "<C-l>", "<Right>", {})

vim.api.nvim_set_keymap("i", "<C-k>", "<Up>", {})
vim.api.nvim_set_keymap("i", "<C-j>", "<Down>", {})
vim.api.nvim_set_keymap("i", "<C-h>", "<Left>", {})
vim.api.nvim_set_keymap("i", "<C-l>", "<Right>", {})

local keymap = vim.keymap.set

keymap("n", "<leader>ww", ":bdelete<CR>", { silent = true })
keymap("n", "<leader>wh", ":NvimTreeToggle<CR>", { silent = true })
keymap("n", "<leader>ff", ":NvimTreeFindFileToggle<CR>", { silent = true })
keymap("n", "<C-n>", ":bnext<CR>", { silent = true })
keymap("n", "<C-p>", ":bprev<CR>", { silent = true })
keymap("x", "<", "<gv", { noremap = true, silent = true })
keymap("x", ">", ">gv", { noremap = true, silent = true })

-- format
-- keymap('n', '<leader>fmt', ':Format<CR>', { silent = true })
keymap(
	"n",
	"<leader>fmt",
	':lua require("conform").format({ async = true, lsp_format = "fallback" })<CR>',
	{ silent = true }
)

-- LSP
keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })
keymap("n", "<leader>h", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
keymap({ "n", "v" }, "<leader>ga", "<cmd>Lspsaga code_action<CR>", { silent = true })

-- switch project
keymap("n", "<leader>lw", ":lua require'telescope'.extensions.project.project{}<CR>", { noremap = true, silent = true })

-- Diagnostic jump can use `<c-o>` to jump back
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

-- DAP debugger
keymap("n", "<leader>dc", ":lua require'dap'.continue()<CR>", { silent = true })
keymap("n", "<leader>d_", ":lua require'dap'.run_to_cursor()<CR>", { silent = true })
keymap("n", "<leader>do", ":lua require'dap'.step_over()<CR>", { silent = true })
keymap("n", "<leader>dO", ":lua require'dap'.step_out()<CR>", { silent = true })
keymap("n", "<leader>di", ":lua require'dap'.step_into()<CR>", { silent = true })
keymap("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
keymap("n", "<leader>dd", ":lua require'dap'.repl.open()<CR>", { silent = true })
keymap("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", { silent = true })

-- Git
keymap("n", "<leader>bb", ":Gitsigns blame_line<CR>", { silent = true })
keymap("n", "]x", "<Plug>(git-conflict-prev-conflict)")
keymap("n", "[x", "<Plug>(git-conflict-next-conflict)")

-- Highlight selected
keymap("v", "<leader>hl", ":<c-u>HSHighlight<CR>", { noremap = true, silent = true })
keymap("n", "<leader>hr", ":HSRmHighlight rm_all<CR>", { noremap = true, silent = true })

-- Terminal
keymap("n", "<leader>tt", ":ToggleTerm<CR>", { noremap = true, silent = true })
