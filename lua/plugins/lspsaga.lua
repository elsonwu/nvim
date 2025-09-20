-- TODO should be removed when the bug is fixed on lspsaga
-- https://github.com/nvimdev/lspsaga.nvim/issues/1520
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false, -- Disable updating diagnostics in insert mode
  underline = true,
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = '●',
  },
})

return {
  "glepnir/lspsaga.nvim",
  branch = "main",
  event = "LspAttach",
  dependencies = {
    {'nvim-treesitter/nvim-treesitter', lazy = true}, -- Make dependency lazy
    {'nvim-tree/nvim-web-devicons', lazy = true},     -- Make dependency lazy
  },
  opts = {
    request_timeout = 8000, -- Increase timeout for references
    lightbulb = {
      enable = false, -- Disable lightbulb for performance
    },
    finder = {
      max_height = 0.6, -- Limit height for better performance
      max_width = 0.8,  -- Limit width
      silent = true,     -- Reduce noise
      timeout = 8000,    -- Increase timeout for finder
    },
    definition = {
      width = 0.6, -- Limit width for better performance
      height = 0.5, -- Limit height for better performance
    },
    -- Add specific optimizations for references
    references = {
      ignore_when_no_reference = true,
      max_results = 100,  -- Limit results for performance
    },
  },
}
