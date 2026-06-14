return {
  "williamboman/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
  config = function()
    -- vim.lsp.config() calls must come before mason-lspconfig.setup() so that
    -- automatic_enable picks them up when it calls vim.lsp.enable() per server.
    vim.lsp.config("*", {
      capabilities = vim.lsp.protocol.make_client_capabilities(),
    })

    -- jdtls requires Java 21; inject JAVA_HOME without changing system Java
    vim.lsp.config("jdtls", {
      cmd_env = {
        JAVA_HOME = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
      },
    })

    -- ESLint: only start if project has ESLint config
    vim.lsp.config("eslint", {
      root_dir = function(fname)
        local eslint_configs = {
          ".eslintrc.js", ".eslintrc.json", ".eslintrc.yml", ".eslintrc.yaml",
          ".eslintrc.cjs", "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
        }
        return require("lspconfig.util").root_pattern(unpack(eslint_configs))(fname)
      end,
      settings = {
        workingDirectory = { mode = "auto" },
        format = { enable = true },
        lint = { enable = true },
        run = "onType",
      },
      filetypes = {
        "javascript", "javascriptreact", "typescript", "typescriptreact",
        "vue", "svelte", "astro",
      },
    })

    require("mason-lspconfig").setup({
      automatic_installation = true,
      ensure_installed = { "vtsls", "jdtls", "yamlls", "lua_ls", "eslint" },
    })
  end,
}
