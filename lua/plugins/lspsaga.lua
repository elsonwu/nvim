-- TODO should be removed when the bug is fixed on lspsaga
-- https://github.com/nvimdev/lspsaga.nvim/issues/1520
vim.diagnostic.config({
  severity_sort = true,
})

return {
  "glepnir/lspsaga.nvim",
  branch = "main",
  event = "LspAttach",
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons',     -- optional
  },
  opts = {
    request_timeout = 5000,
  },
}
