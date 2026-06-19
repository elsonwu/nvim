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
      -- File explorer (replaces nvim-tree)
      explorer = { enabled = true },
      -- Picker: remap explorer's o from system-open to open-in-nvim
      picker = {
        sources = {
          explorer = {
            hidden = true,   -- show dotfiles by default (H to toggle)
            ignored = true,  -- show gitignored files by default (I to toggle)
            -- exclude heavy build artifacts to keep git-ignored scanning fast
            exclude = { ".git", "node_modules", "build", "dist", "target", ".gradle" },
            win = {
              list = {
                keys = {
                  ["o"] = "confirm",
                  -- `l`/`h` scroll the tree right/left (native zL/zH) instead of
                  -- opening/collapsing, so deep-tree filenames come into view.
                  -- `o` opens files and toggles dirs (expand/collapse).
                  ["l"] = function() vim.cmd("normal! zL") end,
                  ["h"] = function() vim.cmd("normal! zH") end,
                  -- `/` launches fzf-lua files (respects .gitignore, same as \sf)
                  -- scoped to the focused node's dir, instead of snacks' fd search
                  -- that ignores .gitignore. `i` still opens the native filter.
                  ["/"] = function(_, item)
                    local dir = vim.fn.getcwd()
                    if item and item.file and item.file ~= "" then
                      dir = vim.fn.isdirectory(item.file) == 1 and item.file
                        or vim.fn.fnamemodify(item.file, ":h")
                    end
                    require("fzf-lua").files({ cwd = dir })
                  end,
                  ["yp"] = function(picker, item)
                    local path = item and item.file or ""
                    if path ~= "" then
                      vim.fn.setreg("+", path)
                      vim.notify(path, vim.log.levels.INFO)
                    end
                  end,
                  ["yr"] = function(picker, item)
                    local path = item and item.file or ""
                    if path ~= "" then
                      path = vim.fn.fnamemodify(path, ":.")
                      vim.fn.setreg("+", path)
                      vim.notify(path, vim.log.levels.INFO)
                    end
                  end,
                },
              },
            },
          },
        },
      },
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
