vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.wrap = true
vim.opt.number = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.hls = true
vim.opt.swapfile = false
vim.opt.smartcase = true
vim.opt.history = 1000
vim.opt.showcmd = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
-- vim.opt.clipboard = vim.opt.clipboard + 'unnamedplus'
vim.opt.termguicolors = true
vim.opt.updatetime = 300

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- command reload config
vim.api.nvim_create_user_command("ReloadConfig", "source $MYVIMRC", {})

-- Copilet
vim.g.copilot_node_command = "~/.local/share/fnm/aliases/default/bin/node"
vim.g.copilot_no_tab_map = true

-- better diagnostic sign
local signs = { Error = "🚨", Warn = "⚠️ ", Hint = "💡", Info = "⚡" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

pcall(vim.cmd, "colorscheme dracula")
