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
      settings = {
        java = {
          -- Code-review workflow: disable incremental autobuild (recompiles on
          -- every change = pure CPU churn when you're only navigating). Maven/
          -- Gradle import stays ON (default) so classpath resolution + cross-dep
          -- go-to-definition still work. Trade-off: compile diagnostics won't
          -- refresh live — acceptable for read-only review.
          autobuild = { enabled = false },
        },
      },
      -- Heap intentionally NOT capped: the mason jdtls launcher sets no -Xmx,
      -- so the JVM uses ~25% of RAM (~9G on this 36G machine). Adding -Xmx4g
      -- would LOWER that cap and increase GC pressure. See CLAUDE.md gotcha.
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

    -- pyright: code-review only — disable type checking to suppress noisy
    -- diagnostics; go-to-definition works purely from static analysis (no venv needed).
    vim.lsp.config("pyright", {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "off",
          },
        },
      },
    })

    require("mason-lspconfig").setup({
      automatic_installation = true,
      -- tsgo = TypeScript 7 native (Go) LSP, replaces vtsls. Mason-managed, so
      -- automatic_enable starts it like the others. Much faster project load.
      ensure_installed = { "tsgo", "jdtls", "yamlls", "lua_ls", "eslint", "pyright" },
    })
  end,
}
