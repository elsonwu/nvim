-- Performance related settings
local M = {}

function M.setup()
  -- Core performance settings
  vim.o.lazyredraw = true
  vim.o.updatetime = 250
  vim.o.timeoutlen = 500  -- Faster key sequence timeout
  vim.o.ttimeoutlen = 10  -- Faster key code timeout

  -- UI optimizations
  vim.o.showcmd = false
  vim.o.showmode = false
  vim.o.cursorline = false  -- Disable for better performance
  vim.o.wrap = false
  vim.o.ruler = false
  vim.o.foldmethod = "manual"  -- Manual folding is fastest

  -- Reduce syntax highlighting for long lines
  vim.o.synmaxcol = 240

  -- File handling optimizations
  vim.o.backup = false
  vim.o.writebackup = false
  vim.o.swapfile = false
  vim.o.undofile = true  -- Enable persistent undo but disable swap
  
  -- Memory and processing optimizations
  vim.o.maxmempattern = 2000  -- Increase pattern memory
  vim.o.regexpengine = 1  -- Use old regexp engine (sometimes faster)
  
  -- Optimize matchparen
  vim.g.matchup_matchparen_enabled = 0
  vim.g.matchup_matchparen_fallback = false
  
  -- Disable heavy built-in plugins if not already done
  vim.g.loaded_matchparen = 1
  vim.g.loaded_matchit = 1
  
  -- Terminal optimizations
  vim.g.terminal_color_depth = 8

  -- Session optimizations
  vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize"

  -- Use faster grep tools
  if vim.fn.executable('rg') == 1 then
    vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'
    vim.o.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  elseif vim.fn.executable('ag') == 1 then
    vim.o.grepprg = 'ag --vimgrep'
    vim.o.grepformat = '%f:%l:%c:%m'
  end

  -- Optimize autocommands
  local augroup = vim.api.nvim_create_augroup("performance_opts", { clear = true })

  -- Disable syntax for large files
  vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      local line_count = vim.api.nvim_buf_line_count(buf)
      local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(buf))
      
      -- Disable heavy features for large files
      if line_count > 5000 or file_size > 512 * 1024 then -- 512KB
        vim.cmd("syntax clear")
        vim.bo.syntax = "off"
        vim.bo.filetype = ""
        vim.wo.foldmethod = "manual"
        vim.wo.spell = false
        vim.wo.cursorline = false
        vim.wo.cursorcolumn = false
        -- Disable LSP for very large files
        vim.defer_fn(function()
          vim.cmd("LspStop")
        end, 100)
      end
    end,
    group = augroup,
  })

  -- Optimize search highlighting
  vim.api.nvim_create_autocmd("CmdlineEnter", {
    pattern = "/,\\?",
    command = "set hlsearch",
    group = augroup,
  })
  vim.api.nvim_create_autocmd("CmdlineLeave", {
    pattern = "/,\\?",
    command = "set nohlsearch",
    group = augroup,
  })

  -- Optimize completion behavior
  vim.o.completeopt = "menuone,noselect"
  vim.o.pumheight = 15  -- Limit popup menu height
  
  -- Add large file optimizations for other plugins
  vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = "*",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      
      if ok and stats and stats.size > 1024 * 1024 then -- 1MB
        -- Disable expensive features for very large files
        vim.b.large_file = true
        vim.bo.eventignore = "FileType"
        vim.bo.undolevels = -1
        vim.bo.undoreload = 0
        vim.wo.list = false
        vim.wo.spell = false
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = "no"
      end
    end,
    group = augroup,
  })
  
  -- Faster redraw
  vim.o.ttyfast = true
end

return M
