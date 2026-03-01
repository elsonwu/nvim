return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  lazy = true,
  opts = {
    formatters_by_ft = {
      -- lua = { "stylua" },
      -- Nested table = use first available formatter (not both sequentially)
      javascript = { { "eslint", "prettierd" } },
      javascriptreact = { { "eslint", "prettierd" } },
      typescript = { { "eslint", "prettierd" } },
      typescriptreact = { { "eslint", "prettierd" } },
      json = { { "jq", "prettierd" } },
      go = { "goimports" },
      rust = { "rustfmt" },
      yaml = { "yamlfmt" },
    },
  },
}
