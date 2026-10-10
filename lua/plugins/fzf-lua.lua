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

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>ff", fzf(function()
        vim.ui.input({ prompt = "Files in: ", completion = "dir", default = vim.fn.expand("%:p:h") }, function(dir)
          if dir and dir ~= "" then require("fzf-lua").files({ cwd = dir }) end
        end)
      end), desc = "Find files in dir" },
    { "<leader>sf", fzf(function() require("fzf-lua").files() end), desc = "Find files" },
    { "<leader>ss", fzf(function() require("fzf-lua").live_grep() end), desc = "Live grep" },
    { "<leader>sb", fzf(function() require("fzf-lua").buffers() end), desc = "Search buffers" },
    { "<leader>sg", fzf(function() require("fzf-lua").git_status() end), desc = "Git status" },
    { "<leader>sw", fzf(function() require("fzf-lua").live_grep({ search = vim.fn.expand("<cword>") }) end), desc = "Live grep word under cursor (editable)" },
    { "<leader>sP", fzf(function()
        vim.ui.input({ prompt = "Grep in dir: ", completion = "dir", default = vim.fn.expand("%:p:h") }, function(dir)
          if dir and dir ~= "" then require("fzf-lua").live_grep({ cwd = dir }) end
        end)
      end), desc = "Live grep in dir" },
    { "<leader>sw", mode = "x", fzf(function()
        vim.cmd('noau normal! "vy"')
        require("fzf-lua").live_grep({ search = vim.fn.getreg("v") })
      end), desc = "Live grep visual selection (editable)" },
    { "<leader>sh", fzf(function() require("fzf-lua").help_tags() end), desc = "Help tags" },
    { "<leader>sd", fzf(function() require("fzf-lua").diagnostics_document() end), desc = "Document diagnostics" },
    { "<leader>sD", fzf(function() require("fzf-lua").diagnostics_workspace() end), desc = "Workspace diagnostics" },
    { "<leader>sr", fzf(function() require("fzf-lua").resume() end), desc = "Resume last search" },
    { "<leader>sc", fzf(function() require("fzf-lua").git_commits() end), desc = "Git commits" },
    { "<leader>sG", fzf(function()
        local files = vim.fn.systemlist("git diff --name-only HEAD 2>/dev/null")
        if #files == 0 then
          vim.notify("No changed files", vim.log.levels.INFO)
          return
        end
        require("fzf-lua").live_grep({ search_dirs = files })
      end), desc = "Grep git changed files" },
    { "<leader>sF", fzf(function() require("fzf-lua").files({ fd_opts = "--type f --hidden --no-ignore --exclude .git" }) end), desc = "Find files (include ignored)" },
    { "<leader>sS", fzf(function() require("fzf-lua").live_grep({ rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore -g '!.git/'" }) end), desc = "Grep all (include ignored)" },
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
      fd_opts = "--type f --hidden --exclude .git --exclude node_modules --exclude target --exclude build --exclude dist",
      follow = true,
    },
    lsp = {
      -- lsp sources (lsp_finder, lsp_references, etc.) hard-default formatter=false,
      -- overriding the global one. Set explicitly to lead with the filename.
      formatter = "path.filename_first",
    },
    grep = {
      -- grep source hard-defaults formatter=false, overriding the global one,
      -- so live_grep would otherwise show the full path with the filename
      -- truncated. Set it explicitly to lead with the filename.
      formatter = "path.filename_first",
      rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git' -g '!node_modules' --max-count 300",
    },
    buffers = {
      sort_lastused = true,
      ignore_current_buffer = true,
    },
    git = {
      status = {
        preview_pager = false,
      },
    },
    fzf_opts = {
      ["--layout"] = "reverse",
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
