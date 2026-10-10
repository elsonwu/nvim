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
    -- Scope by pre-filling an *editable* ` -- <dir>/**` glob into the query instead
    -- of setting `cwd`. Setting `cwd` bakes the scope in for the whole picker
    -- session; as a glob it stays changeable while you type the keyword in front
    -- of it. The `ui.input` step survives only for its `completion = "dir"` tab
    -- completion -- fzf's query line has none.
    { "<leader>sP", fzf(function()
        vim.ui.input({ prompt = "Grep in dir: ", completion = "dir", default = vim.fn.expand("%:p:h") }, function(dir)
          if not dir or dir == "" then return end
          local rel = vim.fn.fnamemodify(vim.fn.fnamemodify(dir, ":p"), ":.")
          rel = rel:gsub("/+$", "")
          if rel == "" then
            -- dir *is* cwd: `fnamemodify(cwd, ":.")` returns "", and rg rejects a
            -- `./**` style glob outright, so scope to nothing at all.
            require("fzf-lua").live_grep()
          elseif rel:sub(1, 1) == "/" then
            -- outside cwd, so it stayed absolute -- rg matches globs against
            -- cwd-relative paths and can't express this. Fall back to `cwd`
            -- (scope is then fixed for the session, as it used to be).
            require("fzf-lua").live_grep({ cwd = dir })
          else
            require("fzf-lua").live_grep({
              -- a bare dir glob matches only the directory entry itself, never the
              -- files under it, hence `/**`.
              search = " -- " .. rel .. "/**",
              -- Without this, grep.lua:144 runs the prefill through `rg_escape`,
              -- turning it into a literal `\-\- lua/plugins/\*\*`: the ` -- `
              -- separator stops matching and the escapes show up in the input box.
              -- It also makes the keyword half a raw regex, same as plain `\ss`
              -- (`\sw` deliberately keeps escaping, since a cword should be literal).
              no_esc = true,
              -- `--query` leaves the cursor at the end; push it to the keyword half.
              -- The `+` prefix APPENDS to fzf-lua's own `start:+transform:<reload>`
              -- bind (core.lua:640). Without it fzf keeps only the last `start` bind
              -- and live reloading silently stops working.
              keymap = { fzf = { start = "+beginning-of-line" } },
            })
          end
        end)
      end), desc = "Live grep in dir (editable scope)" },
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
      -- Make the ` -- <glob>` half of a live_grep query forgiving, VSCode-style.
      -- rg's globs are anchored to the *whole basename* and ignore directory
      -- components unless the glob contains `/`, so bare `Virtual*` means
      -- "filename starts with Virtual" and silently matches nothing when you
      -- meant "path contains Virtual". Here a token without `/` is rewritten to
      -- a substring match: `Virtual`, `Virtual*` and `*Virtual` all become
      -- `*Virtual*`; `!test` becomes `!*test*`.
      -- Escape hatch: any token containing `/` is passed through verbatim
      -- (`**/api/**`, `src/**/*.tsx`), which is also how you get strict
      -- anchoring back when you want it (`**/*.tsx`, not `*.tsx*`).
      --
      -- MUST stay self-contained. live_grep forces multiprocess=1 and ships
      -- this function to a headless instance via `string.dump`, which returns
      -- the function "with new upvalues" -- i.e. drops them (fzf-lua
      -- config.lua:1060, make_entry.lua:89). Anything referenced from the
      -- enclosing file arrives as nil there, and *only* there, so a broken
      -- version would still look fine in a same-process test.
      rg_glob_fn = function(query, opts)
        local libuv = require("fzf-lua.libuv")
        local search_query, glob_str = query:match("(.*)" .. opts.glob_separator .. "(.*)")
        local globs, glob_args = {}, ""
        for _, token in ipairs(vim.split(glob_str or "", "%s+", { trimempty = true })) do
          local neg, body = token:match("^(!?)(.*)$")
          if #body > 0 then
            if not body:find("/", 1, true) then
              local core = body:gsub("^%*+", "")
              core = core:gsub("%*+$", "")
              body = "*" .. core .. "*"
            end
            local glob = neg .. body
            table.insert(globs, glob)
            glob_args = glob_args .. ("%s %s "):format(opts.glob_flag, libuv.shellescape(glob))
          end
        end
        return search_query or "", glob_args, globs
      end,
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
