return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("snacks").setup({
      -- Replaces manual large-file autocmds in performance.lua
      bigfile = {
        enabled = true,
        size = 256 * 1024, -- 256KB
        notify = true,
      },
      -- Better buffer deletion without breaking window layout
      bufdelete = { enabled = true },
      -- Dashboard (replaces alpha-nvim)
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "f", desc = "Find File", action = ":FzfLua files" },
            { icon = " ", key = "g", desc = "Live Grep", action = ":FzfLua live_grep" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":FzfLua oldfiles" },
            { icon = " ", key = "c", desc = "Config", action = ":FzfLua files cwd=~/.config/nvim" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      -- Open file/repo in browser
      gitbrowse = { enabled = true },
      -- Notifications (replaces fidget.nvim)
      notifier = {
        enabled = true,
        timeout = 3000,
        style = "compact",
      },
      -- LSP word references navigation
      words = {
        enabled = true,
        debounce = 200,
      },
      -- Better vim.ui.input
      input = { enabled = true },
      -- Scope detection
      scope = { enabled = true },
      -- Indent guides
      indent = {
        enabled = true,
        animate = { enabled = false }, -- No animation for performance
      },
    })
  end,
  keys = {
    { "<leader>ww", function() Snacks.bufdelete() end, desc = "Delete buffer" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser" },
    { "]]", function() Snacks.words.jump(1) end, desc = "Next LSP reference" },
    { "[[", function() Snacks.words.jump(-1) end, desc = "Prev LSP reference" },
    { "<leader>nn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
  },
}
