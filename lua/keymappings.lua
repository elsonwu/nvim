local keymap = vim.keymap.set

-- Command mode navigation
keymap("c", "<C-k>", "<Up>")
keymap("c", "<C-j>", "<Down>")
keymap("c", "<C-h>", "<Left>")
keymap("c", "<C-l>", "<Right>")

-- Insert mode navigation
keymap("i", "<C-k>", "<Up>")
keymap("i", "<C-j>", "<Down>")
keymap("i", "<C-h>", "<Left>")
keymap("i", "<C-l>", "<Right>")

-- File explorer keymaps defined in lua/plugins/oil.lua

-- Buffer navigation
keymap("n", "<C-n>", ":bnext<CR>", { silent = true })
keymap("n", "<C-p>", ":bprev<CR>", { silent = true })
keymap("x", "<", "<gv", { silent = true })
keymap("x", ">", ">gv", { silent = true })

-- Clear search highlights
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- LSP (native Neovim 0.11)
keymap("n", "gd", vim.lsp.buf.definition, { silent = true, desc = "Go to definition" })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { silent = true, desc = "Rename" })
keymap("n", "<leader>h", function() require("fzf-lua").lsp_definitions() end, { silent = true, desc = "Peek definition" })
keymap("n", "<leader>gt", function() require("fzf-lua").lsp_typedefs() end, { silent = true, desc = "Peek type definition" })
keymap("n", "<leader>gr", function() require("fzf-lua").lsp_finder() end, { silent = true, desc = "LSP finder" })
keymap("n", "<leader>gE", function() require("fzf-lua").diagnostics_workspace() end, { silent = true, desc = "Workspace diagnostics" })
keymap("n", "<leader>ge", function() require("fzf-lua").diagnostics_document() end, { silent = true, desc = "Buffer diagnostics" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { silent = true, desc = "Code action" })
keymap("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { silent = true, desc = "Prev diagnostic" })
keymap("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { silent = true, desc = "Next diagnostic" })
keymap("n", "K", vim.lsp.buf.hover, { silent = true, desc = "Hover doc" })

-- Keymap search
keymap("n", "<leader>?", function() require("fzf-lua").keymaps() end, { silent = true, desc = "Search keymaps" })

-- Quit all
keymap("n", "<leader>qq", "<cmd>qa<CR>", { silent = true, desc = "Quit all" })

-- Git
keymap("n", "<leader>bb", ":Gitsigns blame_line<CR>", { silent = true })

-- Format buffer (filetype-aware: jq for JSON, LSP otherwise)
keymap("n", "<leader>fmt", function()
  local ft = vim.bo.filetype
  local view = vim.fn.winsaveview()
  local cli = ({ json = "jq .", jsonc = "jq .", xml = "xmllint --format - | sed 's|/>| />|g'" })[ft]
  if cli and vim.fn.executable(vim.split(cli, " ")[1]) == 1 then
    vim.cmd("silent %!" .. cli)
    if vim.v.shell_error ~= 0 then
      vim.cmd("silent undo")
      vim.notify(cli .. " failed (invalid " .. ft .. "?)", vim.log.levels.ERROR)
    end
  else
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end
  vim.fn.winrestview(view)
end, { silent = true, desc = "Format buffer" })

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
end, { silent = true, desc = "Smart paste (disables syntax temporarily)" })
