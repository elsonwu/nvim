return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  lazy = true,
  opts = {
    formatters_by_ft = {
      -- lua = { "stylua" },
      javascript = { "eslint", "prettierd" },
      javascriptreact = { "eslint", "prettierd" },
      typescript = { "eslint", "prettierd" },
      typescriptreact = { "eslint", "prettierd" },
      json = { "jq", "prettierd" },
      go = { "goimports" },
      rust = { "rustfmt" },
      yaml = { "yamlfmt" },
    },
    default_format_opts = {
      stop_after_first = true,
    },
  },
}
