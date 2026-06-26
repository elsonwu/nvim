return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && pnpm install",
  ft = { "markdown" },
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  init = function()
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_theme = "dark"
  end,
}
