return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  lazy = true,
  opts = {
    formatters_by_ft = {
      -- lua = { "stylua" },
      -- Use a sub-list to run only the first available formatter
      javascript = { "eslint", "prettierd" },
      javascriptreact = { "eslint", "prettierd" },
      typescript = { "eslint", "prettierd" },
      typescriptreact = { "eslint", "prettierd" },
      json = { "jq", "prettierd" },
      go = { "goimports" },
      rust = { "rustfmt" },
      yaml = { "yamlfmt" },
    },
  },
}
