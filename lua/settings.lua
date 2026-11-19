-- Editor behavior
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.number = true

vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
-- <C-o>/<C-i> act like browser back/forward (stack) and restore each jump's
-- scroll position (view), so returning from a `gd` jump doesn't re-center the
-- screen. `clean` (the default) drops entries for deleted buffers.
vim.opt.jumpoptions = "clean,stack,view"

-- Performance: vim options (single source of truth)
vim.opt.synmaxcol = 240              -- Limit syntax highlighting for long lines
vim.opt.updatetime = 250             -- Faster updates (from default 4000ms)
vim.opt.timeoutlen = 300             -- Faster key sequence timeout
vim.opt.ttimeoutlen = 10             -- Faster escape sequence timeout
vim.opt.redrawtime = 1500            -- Limit redraw time for complex syntax
vim.opt.maxmempattern = 20000        -- Increase memory for pattern matching (fixes E363 for JSON)
vim.opt.writebackup = false          -- Disable backup before overwrite
vim.opt.swapfile = false             -- Disable swap files
vim.opt.undofile = true              -- Enable persistent undo
vim.opt.foldlevelstart = 99          -- Start with all folds open
vim.opt.completeopt = "menuone,noselect"
vim.opt.pumheight = 15               -- Limit popup menu height
vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize"

-- Performance: UI
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.wrap = false
vim.opt.ruler = false

-- command reload config
vim.api.nvim_create_user_command("ReloadConfig", "source $MYVIMRC", {})

-- Copy file path to clipboard
vim.keymap.set("n", "<leader>yp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.fn.setreg("*", path)
  vim.notify(path, vim.log.levels.INFO)
end, { desc = "Yank absolute file path" })

vim.keymap.set("n", "<leader>yr", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.fn.setreg("*", path)
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

-- Indent-based folding: indent IS the structure in these languages.
-- Everything with a treesitter parser gets treesitter folds (see
-- nvim-treesitter.lua); this runs after that and overrides it.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("indent_fold", { clear = true }),
  pattern = { "yaml", "python", "toml" },
  callback = function()
    vim.opt_local.foldmethod = "indent"
  end,
})

-- Long JSON lines (minified payloads): highlight further than the global 240.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("json_synmaxcol", { clear = true }),
  pattern = { "json", "jsonc" },
  callback = function(args) vim.bo[args.buf].synmaxcol = 500 end,
})

-- Markdown `gd`: open the `path`, [label](path) or bare path under the cursor
-- (relative to the current file), falling back to LSP definition.
local function follow_md_link()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  local path = nil

  -- 1. Backtick span: `path/to/file`
  local pos = 1
  while not path do
    local ms, me, p = line:find("`([^`]+)`", pos)
    if not ms then break end
    if col >= ms and col <= me then path = p end
    pos = me + 1
  end

  -- 2. Markdown link: [label](path) or ![alt](path)
  if not path then
    pos = 1
    while not path do
      local ms, me, p = line:find("%!?%[[^%]]*%]%(([^%)]+)%)", pos)
      if not ms then break end
      if col >= ms and col <= me then path = p end
      pos = me + 1
    end
  end

  -- 3. Bare path under cursor (same logic as built-in gf)
  if not path or path == "" then
    path = vim.fn.expand("<cfile>")
  end

  if not path or path == "" then
    vim.lsp.buf.definition()
    return
  end

  -- Resolve relative to current file's directory
  if not vim.startswith(path, "/") and not path:match("^%a+://") then
    path = vim.fn.expand("%:p:h") .. "/" .. path
  end

  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("md_keymaps", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "gd", follow_md_link, { buffer = 0, silent = true, desc = "Follow markdown link" })
  end,
})

-- File type detection (single source of truth)
vim.filetype.add({
  extension = {
    mdx = "markdown",
    avdl = "java",
  },
})
