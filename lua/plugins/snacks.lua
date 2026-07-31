-- snacks' list_down/list_up force cursor col to 0 on every move, which
-- (with nowrap) yanks the horizontal scroll back to the left. Wrap them to
-- restore the column after the move so scrolled-right names stay visible.
-- Function-valued win.list.keys entries are called with the win object
-- (not the picker) as their only argument -- see snacks.win:map().
local function move_keep_col(action)
  return function(win)
    local col = vim.api.nvim_win_get_cursor(win.win)[2]
    win:execute(action)
    local row = vim.api.nvim_win_get_cursor(win.win)[1]
    pcall(vim.api.nvim_win_set_cursor, win.win, { row, col })
  end
end

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
      explorer = { enabled = true },
      -- Picker: remap explorer's o from system-open to open-in-nvim
      picker = {
        sources = {
          explorer = {
            hidden = true,   -- show dotfiles by default (H to toggle)
            ignored = true,  -- show gitignored files by default (I to toggle)
            exclude = { ".git", "node_modules", "build", "dist", "target", ".gradle" },
            win = {
              -- native winfixbuf tells other pickers (fzf-lua) not to hijack
              -- this window when jumping to a file -- without it, snacks'
              -- own buffer-swap guard (win.lua fixbuf()) intercepts the jump,
              -- shoves the target buffer into some other window at line 1,
              -- and snaps focus back to the explorer (leader-ss cursor bug).
              input = { wo = { winfixbuf = true } },
              list = {
                wo = { winfixbuf = true },
                keys = {
                  ["o"] = "confirm",
                  -- keep horizontal scroll position when moving up/down
                  -- (see move_keep_col above)
                  ["j"] = move_keep_col("list_down"),
                  ["k"] = move_keep_col("list_up"),
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
                      vim.fn.setreg("*", path)
                      vim.notify(path, vim.log.levels.INFO)
                    end
                  end,
                  ["yr"] = function(picker, item)
                    local path = item and item.file or ""
                    if path ~= "" then
                      path = vim.fn.fnamemodify(path, ":.")
                      vim.fn.setreg("+", path)
                      vim.fn.setreg("*", path)
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
    { "<leader>wh", function()
      local file = vim.fn.expand("%:p")
      local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(vim.fn.expand("%:p:h")) .. " rev-parse --show-toplevel")[1]
      local root = (vim.v.shell_error == 0 and git_root) or vim.fn.getcwd()
      Snacks.picker.explorer({ cwd = root, reveal = file })
    end, desc = "Explorer: reveal current file" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser" },
    { "]]", function() Snacks.words.jump(1) end, desc = "Next LSP reference" },
    { "[[", function() Snacks.words.jump(-1) end, desc = "Prev LSP reference" },
    { "<leader>nn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
  },
}
