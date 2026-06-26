return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI panels (variables, stack, watches, console)
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      -- Inline variable values next to code
      "theHamsta/nvim-dap-virtual-text",
      -- Mason bridge: auto-installs DAP adapters (js-debug-adapter for Node.js)
      { "jay-babu/mason-nvim-dap.nvim", dependencies = { "williamboman/mason.nvim" } },
    },
    keys = {
      { "<leader>db", desc = "Toggle breakpoint" },
      { "<leader>dB", desc = "Conditional breakpoint" },
      { "<leader>dl", desc = "Logpoint" },
      { "<leader>dc", desc = "Continue / Start" },
      { "<leader>ds", desc = "Step over" },
      { "<leader>di", desc = "Step into" },
      { "<leader>do", desc = "Step out" },
      { "<leader>dr", desc = "Run to cursor" },
      { "<leader>dq", desc = "Terminate" },
      { "<leader>du", desc = "Toggle DAP UI" },
      { "<leader>dh", desc = "Hover variable" },
      { "<leader>de", desc = "Evaluate expression", mode = { "n", "v" } },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Mason: auto-install js-debug-adapter and wire up pwa-node/pwa-chrome
      require("mason-nvim-dap").setup({
        ensure_installed = { "js" },
        automatic_installation = true,
        handlers = {}, -- use default handlers (registers pwa-node adapter)
      })

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.40 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks",      size = 0.25 },
              { id = "watches",     size = 0.20 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 12,
            position = "bottom",
          },
        },
      })

      require("nvim-dap-virtual-text").setup({
        display_callback = function(variable, _, _, _, options)
          if #variable.value > 60 then
            return " = " .. string.sub(variable.value, 1, 57) .. "..."
          end
          return " = " .. variable.value
        end,
      })

      -- Node.js launch/attach configs for JS/TS
      local js_config = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach (pick process)",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to :9229",
          port = 9229,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
      }

      for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[lang] = js_config
      end

      -- Auto open/close UI with debug session
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      -- Breakpoint signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "CursorLine", numhl = "" })

      local keymap = vim.keymap.set
      keymap("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      keymap("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
      end, { desc = "Conditional breakpoint" })
      keymap("n", "<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
      end, { desc = "Logpoint" })
      keymap("n", "<leader>dc", dap.continue, { desc = "Continue / Start" })
      keymap("n", "<leader>ds", dap.step_over, { desc = "Step over" })
      keymap("n", "<leader>di", dap.step_into, { desc = "Step into" })
      keymap("n", "<leader>do", dap.step_out, { desc = "Step out" })
      keymap("n", "<leader>dr", dap.run_to_cursor, { desc = "Run to cursor" })
      keymap("n", "<leader>dq", dap.terminate, { desc = "Terminate" })
      keymap("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
      keymap("n", "<leader>dh", function() require("dap.ui.widgets").hover() end, { desc = "Hover variable" })
      keymap({ "n", "v" }, "<leader>de", function() dapui.eval() end, { desc = "Evaluate expression" })
    end,
  },
}
