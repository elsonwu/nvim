-- Editor behavior
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.incsearch = true

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
vim.opt.lazyredraw = false            -- Allow immediate redraws for responsive UI
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

-- Copy file path to clipboard
vim.keymap.set("n", "<leader>yp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO)
end, { desc = "Yank absolute file path" })

vim.keymap.set("n", "<leader>yr", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO)
end, { desc = "Yank relative file path" })

-- When launched with a single directory arg (`nvim ~/www/axd`), cd into it so
-- fzf-lua, grep, and LSP root detection use that directory instead of the shell's pwd.
if #vim.fn.argv() == 1 then
  local arg = vim.fn.argv(0)
  if vim.fn.isdirectory(arg) == 1 then
    vim.cmd.cd(vim.fn.fnameescape(arg))
  end
end

-- Indent-based folding for common file types
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("indent_fold", { clear = true }),
  pattern = {
    "yaml", "json", "lua",
    "javascript", "typescript", "javascriptreact", "typescriptreact",
    "kotlin", "swift", "java",
    "html", "css", "scss",
    "python", "toml", "vim",
  },
  callback = function()
    vim.opt_local.foldmethod = "indent"
  end,
})

-- File type detection (single source of truth)
vim.filetype.add({
  extension = {
    mdx = "markdown",
    avdl = "java",
  },
})
