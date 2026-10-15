-- Snacks explorer's list/input windows are real windows but rendered as
-- floats dressed up to look like a sidebar, with `winfixbuf` set on them
-- (see snacks.lua) so fzf-lua won't hijack them when jumping to a result.
-- But fzf-lua's fallback for a winfixbuf *current* window is a plain
-- `:split`, and `:split` can't split a float -- it silently splits the
-- real edit window sitting behind it instead, stranding that window's old
-- (usually empty) buffer in a new phantom pane. Step out of the explorer
-- into the largest real (non-floating, non-winfixbuf) window before
-- launching any picker that can open a file/buffer, so fzf-lua never sees
-- a winfixbuf window as current in the first place.
local function focus_edit_win()
  local cur = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(cur).relative == "" and not vim.wo[cur].winfixbuf then
    return -- already in a normal window
  end
  local best, best_area = nil, -1
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local cfg = vim.api.nvim_win_get_config(w)
    if cfg.relative == "" and not vim.wo[w].winfixbuf then
      local area = vim.api.nvim_win_get_width(w) * vim.api.nvim_win_get_height(w)
      if area > best_area then
        best, best_area = w, area
      end
    end
  end
  if best then vim.api.nvim_set_current_win(best) end
end

-- Wrap a picker-launching function so it always steps out of the explorer first.
local function fzf(fn)
  return function()
    focus_edit_win()
    fn()
  end
end

-- fzf-lua.utils (ansi_codes) can't be required yet when this spec is read.
local function ansi(code, s) return ("\27[%sm%s\27[0m"):format(code, s) end
local fd_opts = "--type f --hidden --exclude .git --exclude node_modules --exclude target --exclude build --exclude dist"

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    -- One search for everything: `name/text -- path` (see lua/search.lua).
    { "<leader><leader>", fzf(function() require("search").open() end), desc = "Search files + content" },
    { "<leader><leader>", mode = "x", fzf(function()
        vim.cmd('noau normal! "vy"')
        local text = vim.fn.getreg("v"):match("[^\n]*")
        require("search").open({ query = vim.fn.escape(text, [[\.^$*+?()[]{}|]]) })
      end), desc = "Search selection" },
    { "<leader>sr", fzf(function() require("fzf-lua").resume() end), desc = "Resume last search" },
    { "<leader>sg", fzf(function() require("fzf-lua").git_status() end), desc = "Git status" },
    { "<leader>sc", fzf(function() require("fzf-lua").git_commits() end), desc = "Git commits" },
    { "<leader>sd", fzf(function() require("fzf-lua").diagnostics_document() end), desc = "Document diagnostics" },
    { "<leader>sD", fzf(function() require("fzf-lua").diagnostics_workspace() end), desc = "Workspace diagnostics" },
    { "<leader>sh", fzf(function() require("fzf-lua").help_tags() end), desc = "Help tags" },
  },
  opts = {
    -- Show filename FIRST, dir dimmed + trailing (VSCode-style). Without this,
    -- fzf-lua leads with the full relative path; deep trees (e.g. Java
    -- src/main/java/.../datasources/) share an identical prefix and the unique
    -- filename gets truncated off-screen. Applies to files/grep/LSP/lsp_finder.
    formatter = "path.filename_first",
    winopts = {
      height = 0.85,
      width = 0.85,
      border = "single",
      preview = {
        default = "builtin",
        delay = 100,
        scrollbar = false,
      },
    },
    files = {
      fd_opts = fd_opts,
      follow = true,
    },
    lsp = {
      -- lsp sources (lsp_finder, lsp_references, etc.) hard-default formatter=false,
      -- overriding the global one. Set explicitly to lead with the filename.
      formatter = "path.filename_first",
      -- `gd`: one list for whatever is under the cursor. Incoming calls are left
      -- out on purpose: every call site is already a `ref` row.
      finder = {
        providers = {
          { "definitions", prefix = ansi("32", "def ") },
          { "implementations", prefix = ansi("32", "impl") },
          { "references", prefix = ansi("34", "ref ") },
          { "outgoing_calls", prefix = ansi("33", "out ") },
        },
        includeDeclaration = false, -- already the `def` row
        ignore_current_line = true,
      },
    },
    git = {
      status = {
        preview_pager = false,
      },
    },
    fzf_opts = {
      ["--layout"] = "reverse",
      ["-i"] = "", -- always case-insensitive (default --smart-case breaks on all-caps queries)
    },
    keymap = {
      builtin = {
        ["<C-d>"] = "preview-page-down",
        ["<C-u>"] = "preview-page-up",
      },
      fzf = {
        ["ctrl-q"] = "select-all+accept",
      },
    },
    -- Skip previewing large files
    previewers = {
      builtin = {
        limit_b = 100 * 1024, -- 100KB
      },
    },
  },
}
