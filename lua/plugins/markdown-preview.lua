return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install", -- pnpm doesn't hoist @chemzqm/msgpack-lite alias, breaks require('msgpack-lite')
  ft = { "markdown" },
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  init = function()
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_theme = "dark"
  end,
}
