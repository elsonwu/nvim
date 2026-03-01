-- Performance: runtime logic and autocommands only
-- (All vim.o/vim.opt settings are in settings.lua)
local M = {}

function M.setup()
  -- Disable matchparen/matchit (heavy on large files)
  vim.g.matchup_matchparen_enabled = 0
  vim.g.matchup_matchparen_fallback = false
  vim.g.loaded_matchparen = 1
  vim.g.loaded_matchit = 1

  -- Terminal optimizations
  vim.g.terminal_color_depth = 8

  -- Use faster grep tools
  if vim.fn.executable('rg') == 1 then
    vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'
    vim.o.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  elseif vim.fn.executable('ag') == 1 then
    vim.o.grepprg = 'ag --vimgrep'
    vim.o.grepformat = '%f:%l:%c:%m'
  end

  -- Autocommands
  local augroup = vim.api.nvim_create_augroup("performance_opts", { clear = true })

  -- Mark large files early (BufReadPre)
  vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = "*",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      local file_path = vim.api.nvim_buf_get_name(buf)
      local file_size = vim.fn.getfsize(file_path)
      if file_size > 256 * 1024 then -- 256KB
        vim.b.large_file = true
      end
    end,
    group = augroup,
  })

  -- Disable heavy features for large files (BufReadPost)
  vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      local line_count = vim.api.nvim_buf_line_count(buf)
      local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(buf))
      if vim.b.large_file or line_count > 5000 or file_size > 256 * 1024 then
        vim.notify("Large file detected - disabling heavy features", vim.log.levels.WARN)
        vim.cmd("syntax clear")
        vim.bo.syntax = "off"
        vim.bo.filetype = ""
        vim.wo.foldmethod = "manual"
        vim.wo.spell = false
        vim.wo.cursorline = false
        vim.wo.cursorcolumn = false
        vim.wo.list = false
        vim.schedule(function()
          pcall(vim.cmd, "LspStop")
        end)
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

  -- Disable problematic autocommands for large files in insert mode
  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
      if vim.b.large_file then
        vim.opt_local.eventignore:append({"TextChangedI", "TextChangedP"})
      end
    end,
    group = augroup,
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      if vim.b.large_file then
        vim.opt_local.eventignore:remove({"TextChangedI", "TextChangedP"})
      end
    end,
    group = augroup,
  })

  -- Detect when buffer becomes large during editing (e.g., pasting large JSON)
  vim.api.nvim_create_autocmd("TextChanged", {
    pattern = "*",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      if not vim.b.large_file then
        local line_count = vim.api.nvim_buf_line_count(buf)
        if line_count > 1000 then
          -- Use nvim_buf_get_offset for O(1) byte count instead of iterating lines
          local buf_size = vim.api.nvim_buf_get_offset(buf, line_count)
          if buf_size > 100 * 1024 then
            vim.b.large_file = true
            vim.notify("Large content detected - simplifying syntax", vim.log.levels.WARN)
            vim.bo.syntax = "off"
            vim.cmd("syntax off")
          end
        end
      end
    end,
    group = augroup,
  })

  -- Special handling for JSON files with large arrays
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {"json", "jsonc"},
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      vim.bo[buf].synmaxcol = 500  -- Allow longer lines for JSON
      vim.bo[buf].indentexpr = ""  -- Disable indent detection (can be slow)
    end,
    group = augroup,
  })
end

return M
