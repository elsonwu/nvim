return {
  "zbirenbaum/copilot.lua",
  enabled = false, -- Disabled: using Claude Code for coding instead
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 150,
      keymap = {
        accept = "<C-J>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      ["*"] = false,
      javascript = true,
      typescript = true,
      typescriptreact = true,
      javascriptreact = true,
      lua = true,
      rust = true,
      python = true,
      go = true,
      java = true,
      yaml = true,
      json = true,
    },
    copilot_node_command = vim.fn.expand("~/.local/share/fnm/aliases/default/bin/node"),
  },
}
