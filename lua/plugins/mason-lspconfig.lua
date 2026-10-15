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

    -- tsgo: lspconfig's config (an alias of `tsc`) picks its binary by running
    -- `<bin> --version` synchronously for up to four candidates, each a ~200ms
    -- node cold start, the first time a TS file opens per project root. Pin
    -- Mason's tsgo and resolve the root with the same markers, minus the probe
    -- (and minus Deno detection, which this config doesn't need).
    vim.lsp.config("tsgo", {
      cmd = { "tsgo", "--lsp", "--stdio" },
      root_dir = function(bufnr, on_dir)
        local markers = { { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }, { ".git" } }
        on_dir(vim.fs.root(bufnr, markers) or vim.fn.getcwd())
      end,
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
      ensure_installed = { "tsgo", "jdtls", "yamlls", "lua_ls", "pyright" },
    })
  end,
}
