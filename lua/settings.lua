vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.hls = true
vim.opt.swapfile = false
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.smartindent = false
vim.opt.history = 1000
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

-- Performance optimizations
vim.opt.synmaxcol = 200           -- Limit syntax highlighting for long lines
vim.opt.updatetime = 250          -- Faster updates (from default 4000ms)
vim.opt.timeoutlen = 300          -- Faster key sequence timeout
vim.opt.ttimeoutlen = 10          -- Faster escape sequence timeout
vim.opt.redrawtime = 1500         -- Limit redraw time for complex syntax
vim.opt.regexpengine = 1          -- Use faster regex engine
vim.opt.lazyredraw = true         -- Don't redraw during macros/commands

-- Reduce work on file operations
vim.opt.backup = false            -- Disable backup files
vim.opt.writebackup = false       -- Disable backup before overwrite

-- Optimize folding
vim.opt.foldmethod = "manual"     -- Disable automatic folding
vim.opt.foldlevelstart = 99       -- Start with all folds open

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- command reload config
vim.api.nvim_create_user_command("ReloadConfig", "source $MYVIMRC", {})

-- Copilet
vim.g.copilot_node_command = "~/.local/share/fnm/aliases/default/bin/node"
vim.g.copilot_no_tab_map = true

pcall(vim.cmd, "colorscheme dracula")

-- File type detection
vim.cmd("autocmd BufNewFile,BufRead *.mdx setfiletype markdown")
