-- Performance: runtime logic and autocommands only
-- (All vim.o/vim.opt settings are in settings.lua)
-- (Large-file handling is in snacks.nvim bigfile module)
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

  local augroup = vim.api.nvim_create_augroup("performance_opts", { clear = true })

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

  -- Special handling for JSON files with large arrays
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json", "jsonc" },
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      vim.bo[buf].synmaxcol = 500
      vim.bo[buf].indentexpr = ""
    end,
    group = augroup,
  })
end

return M
