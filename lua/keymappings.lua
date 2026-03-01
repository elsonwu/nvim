-- Command mode navigation
vim.api.nvim_set_keymap("c", "<C-k>", "<Up>", {})
vim.api.nvim_set_keymap("c", "<C-j>", "<Down>", {})
vim.api.nvim_set_keymap("c", "<C-h>", "<Left>", {})
vim.api.nvim_set_keymap("c", "<C-l>", "<Right>", {})

-- Insert mode navigation
vim.api.nvim_set_keymap("i", "<C-k>", "<Up>", {})
vim.api.nvim_set_keymap("i", "<C-j>", "<Down>", {})
vim.api.nvim_set_keymap("i", "<C-h>", "<Left>", {})
vim.api.nvim_set_keymap("i", "<C-l>", "<Right>", {})

local keymap = vim.keymap.set

-- Buffer management (ww handled by snacks.bufdelete in snacks.lua)
keymap("n", "<leader>wh", ":NvimTreeToggle<CR>", { silent = true })
keymap("n", "<leader>ff", ":NvimTreeFindFileToggle<CR>", { silent = true })

keymap("n", "<C-n>", ":bnext<CR>", { silent = true })
keymap("n", "<C-p>", ":bprev<CR>", { silent = true })
keymap("x", "<", "<gv", { noremap = true, silent = true })
keymap("x", ">", ">gv", { noremap = true, silent = true })

-- Search & replace: <leader>S handled by grug-far.lua keys
-- Fuzzy finder: <leader>sf/ss/sb/sg/sw/sh/sd/sD/sr/sc handled by fzf-lua.lua keys

-- Format
keymap(
  "n",
  "<leader>fmt",
  ':lua require("conform").format({ async = true, lsp_format = true })<CR>',
  { noremap = true, silent = true }
)

-- LSP (via Lspsaga)
keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { noremap = true, silent = true })
keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { noremap = true, silent = true })
keymap("n", "<leader>h", "<cmd>Lspsaga peek_definition<CR>", { noremap = true, silent = true })
keymap("n", "<leader>gt", "<cmd>Lspsaga peek_type_definition<CR>", { noremap = true, silent = true })
keymap("n", "<leader>gr", "<cmd>Lspsaga finder<CR>", { noremap = true, silent = true })
keymap("n", "<leader>gE", "<cmd>Lspsaga show_workspace_diagnostics<CR>", { noremap = true, silent = true })
keymap("n", "<leader>ge", "<cmd>Lspsaga show_buf_diagnostics<CR>", { noremap = true, silent = true })
keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { noremap = true, silent = true })
keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { noremap = true, silent = true })
keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { noremap = true, silent = true })
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { noremap = true, silent = true })

-- Git
keymap("n", "<leader>bb", ":Gitsigns blame_line<CR>", { noremap = true, silent = true })

-- Smart paste for large content (temporarily disables syntax)
keymap("n", "<leader>p", function()
  local syntax_enabled = vim.bo.syntax ~= "off"
  if syntax_enabled then
    vim.cmd("syntax off")
    vim.notify("Paste mode: syntax disabled", vim.log.levels.INFO)
  end
  vim.cmd("normal! p")
  if syntax_enabled then
    vim.defer_fn(function()
      vim.cmd("syntax on")
      vim.notify("Paste complete: syntax enabled", vim.log.levels.INFO)
    end, 100)
  end
end, { noremap = true, silent = true, desc = "Smart paste (disables syntax temporarily)" })

-- Copilot disabled: using Claude Code instead (re-enable in copilot-lua.lua if needed)
