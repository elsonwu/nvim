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

-- File explorer keymaps defined in lua/plugins/snacks.lua (<leader>wh) and fzf-lua.lua (<leader>ff)

-- Buffer navigation
keymap("n", "<C-n>", ":bnext<CR>", { silent = true })
keymap("n", "<C-p>", ":bprev<CR>", { silent = true })
keymap("x", "<", "<gv", { silent = true })
keymap("x", ">", ">gv", { silent = true })

-- Clear search highlights
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- LSP (native Neovim 0.11)
-- `gr` is the one navigation key: definition, implementations, references and
-- outgoing calls of whatever is under the cursor, in one list (providers in
-- plugins/fzf-lua.lua). The built-in gr* maps are dropped so `gr` doesn't wait
-- for a second key; rename / code action keep their leader maps below.
for _, lhs in ipairs({ "grr", "gra", "grn", "gri", "grt", "grx" }) do
  pcall(vim.keymap.del, "n", lhs)
end
pcall(vim.keymap.del, "x", "gra")
keymap("n", "gr", function()
  -- Providers overlap (the "implementation" of a plain function is its own
  -- definition). They run in order, so keeping the first row per line keeps
  -- the most specific label.
  local seen = {}
  require("fzf-lua").lsp_finder({
    headers = false, -- would print "Regex filter: <function>"
    regex_filter = function(item)
      local key = item.filename .. ":" .. item.lnum
      if seen[key] then return false end
      seen[key] = true
      return true
    end,
  })
end, { silent = true, desc = "Definition / refs / impls / calls" })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { silent = true, desc = "Rename" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { silent = true, desc = "Code action" })
keymap("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { silent = true, desc = "Prev diagnostic" })
keymap("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { silent = true, desc = "Next diagnostic" })
-- Float options go straight to hover(): since 0.11 it no longer routes
-- through vim.lsp.handlers, so overriding the handler has no effect.
keymap("n", "K", function()
  vim.lsp.buf.hover({ border = "single", max_width = 80, max_height = 20 })
end, { silent = true, desc = "Hover doc" })

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
