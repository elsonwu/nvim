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
keymap("n", "<leader>ww", "<cmd>bdelete<CR>", { silent = true })
keymap("n", "<leader>wh", ":NvimTreeToggle<CR>", { silent = true })
keymap("n", "<leader>ff", ":NvimTreeFindFileToggle<CR>", { silent = true })

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
  ':lua require("conform").format({ async = true, lsp_format = true })<CR>',
  { noremap = true, silent = true }
)

-- LSP
keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { noremap = true, silent = true })
keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { noremap = true, silent = true })
keymap("n", "<leader>h", "<cmd>Lspsaga peek_definition<CR>", { noremap = true, silent = true })
keymap("n", "<leader>gt", "<cmd>Lspsaga peek_type_definition<CR>", { noremap = true, silent = true })
keymap("n", "<leader>gr", "<cmd>Lspsaga finder<CR>", { noremap = true, silent = true })
keymap("n", "<leader>gE", "<cmd>Lspsaga show_workspace_diagnostics<CR>", { noremap = true, silent = true })
keymap("n", "<leader>ge", "<cmd>Lspsaga show_buf_diagnostics<CR>", { noremap = true, silent = true })
keymap("n", "<leader>ss", '<cmd>lua require("telescope.builtin").live_grep()<CR>')
keymap("n", "<leader>sb", '<cmd>Telescope buffers<CR>', { noremap = true, silent = true })
keymap("n", "<leader>sg", '<cmd>Telescope git_status<CR>', { noremap = true, silent = true })
keymap("n", "<leader>sf", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })


keymap("n", "<leader>sw", require('telescope.builtin').grep_string, { noremap = true, silent = true })

-- Git
keymap("n", "<leader>bb", ":Gitsigns blame_line<CR>", { noremap = true, silent = true })

-- Copilet
keymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
