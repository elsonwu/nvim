-- Editor behavior
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.hls = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.smartindent = false
vim.opt.history = 1000
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

-- Performance: vim options (single source of truth)
vim.opt.synmaxcol = 240              -- Limit syntax highlighting for long lines
vim.opt.updatetime = 250             -- Faster updates (from default 4000ms)
vim.opt.timeoutlen = 300             -- Faster key sequence timeout
vim.opt.ttimeoutlen = 10             -- Faster escape sequence timeout
vim.opt.redrawtime = 1500            -- Limit redraw time for complex syntax
vim.opt.regexpengine = 0             -- Auto-select regex engine (better than forcing old engine)
vim.opt.lazyredraw = true            -- Don't redraw during macros/commands
vim.opt.maxmempattern = 20000        -- Increase memory for pattern matching (fixes E363 for JSON)
vim.opt.backup = false               -- Disable backup files
vim.opt.writebackup = false          -- Disable backup before overwrite
vim.opt.swapfile = false             -- Disable swap files
vim.opt.undofile = true              -- Enable persistent undo
vim.opt.foldmethod = "manual"        -- Manual folding is fastest
vim.opt.foldlevelstart = 99          -- Start with all folds open
vim.opt.completeopt = "menuone,noselect"
vim.opt.pumheight = 15               -- Limit popup menu height
vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize"

-- Performance: UI
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.cursorline = false           -- Disable for better performance
vim.opt.wrap = false
vim.opt.ruler = false

-- command reload config
vim.api.nvim_create_user_command("ReloadConfig", "source $MYVIMRC", {})

-- Copilot disabled: using Claude Code instead (re-enable in lua/plugins/copilot-lua.lua)

pcall(vim.cmd, "colorscheme dracula")

-- File type detection (single source of truth)
vim.filetype.add({
  extension = {
    mdx = "markdown",
    avdl = "java",
  },
})
