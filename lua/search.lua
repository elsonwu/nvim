-- One picker for files, content, and content within a set of files.
-- Query syntax and matching live in bin/search; this only wraps it in fzf-lua.
local M = {}

local script = vim.fn.stdpath("config") .. "/bin/search"

-- Shown for an empty query: open buffers by last use, then v:oldfiles,
-- limited to the cwd, current file left out.
local function recent_files()
  local cwd = vim.fn.getcwd() .. "/"
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  table.sort(bufs, function(a, b) return a.lastused > b.lastused end)
  local seen, out = { [vim.api.nvim_buf_get_name(0)] = true }, {}
  local function add(name)
    if name == "" or seen[name] then return end
    seen[name] = true
    if vim.startswith(name, cwd) and vim.uv.fs_stat(name) then
      out[#out + 1] = name:sub(#cwd + 1)
    end
  end
  for _, b in ipairs(bufs) do add(b.name) end
  for _, f in ipairs(vim.v.oldfiles) do add(f) end
  return out
end

---@param o? { query?: string, cwd?: string, no_ignore?: boolean, changed?: boolean, cursor_start?: boolean }
function M.open(o)
  o = o or {}
  local fzf = require("fzf-lua")
  local esc = require("fzf-lua.libuv").shellescape
  local recent = vim.fn.tempname()
  vim.fn.writefile(recent_files(), recent)

  -- Toggles reopen the picker with the flag flipped and the query kept.
  local function toggle(flag)
    return function(_, opts)
      M.open(vim.tbl_extend("force", o, { [flag] = not o[flag], query = opts.last_query, cursor_start = false }))
    end
  end

  local cmd = ("sh %s%s%s --recent %s -- <query>"):format(esc(script),
    o.no_ignore and " --no-ignore" or "", o.changed and " --changed" or "", esc(recent))
  fzf.fzf_live(cmd, {
    prompt = "Search" .. (o.no_ignore and " +ignored" or "") .. (o.changed and " changed" or "") .. "> ",
    query = o.query,
    cwd = o.cwd,
    exec_empty_query = true,
    multiprocess = true,
    fn_transform = [[return require("fzf-lua.make_entry").file]],
    file_icons = true,
    color_icons = true,
    formatter = "path.filename_first",
    previewer = "builtin",
    actions = vim.tbl_extend("force", require("fzf-lua.config").globals.actions.files, {
      ["alt-i"] = toggle("no_ignore"),
      ["alt-c"] = toggle("changed"),
      ["alt-h"] = false,
      ["alt-f"] = false,
    }),
    fzf_opts = {
      ["--multi"] = true,
      ["--header"] = "name/text -- path   alt-i: +ignored   alt-c: changed only",
    },
    -- Prefilled scope (` -- dir/`): put the cursor in front of it. The `+`
    -- appends to fzf-lua's own start bind; without it live reload stops.
    keymap = o.cursor_start and { fzf = { start = "+beginning-of-line" } } or nil,
  })
end

return M
