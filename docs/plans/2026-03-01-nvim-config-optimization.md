# Neovim Configuration Optimization Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Consolidate duplicated settings, re-enable treesitter/LSP, fix bugs, and improve performance.

**Architecture:** Neovim config using lazy.nvim with modular lua files. Settings consolidated into `settings.lua` (editor options) and `performance.lua` (autocmds + large-file handling only). LSP optimizations moved into `mason-lspconfig.lua` since it's the active LSP setup path.

**Tech Stack:** Neovim, Lua, lazy.nvim

---

### Task 1: Consolidate settings — remove duplicates from performance.lua

**Files:**
- Modify: `lua/settings.lua`
- Modify: `lua/performance.lua`

**Step 1: Update settings.lua to be the single source of truth for vim options**

Remove duplicate options from `performance.lua` that already exist in `settings.lua`. Keep only autocmds and runtime logic in `performance.lua`.

In `settings.lua`, ensure these final values (resolving conflicts):
- `synmaxcol = 240` (performance.lua's value, wider than 200)
- `timeoutlen = 300` (settings.lua's value, snappier than 500)
- `ttimeoutlen = 10`
- `redrawtime = 1500`
- `lazyredraw = true`
- `maxmempattern = 20000`
- `regexpengine = 0` (auto — better than forcing engine 1)
- `updatetime = 250`
- Remove duplicates: `backup`, `writebackup`, `swapfile`, `foldmethod`

In `performance.lua`, remove ALL `vim.o.*` / `vim.opt.*` lines, keeping only:
- `grepprg`/`grepformat` (runtime check for rg/ag)
- All autocmds (large file detection, search highlight, etc.)
- matchparen/matchit disabling (vim.g)

**Step 2: Remove duplicate netrw disabling from settings.lua**

Remove `vim.g.loaded_netrw = 1` and `vim.g.loaded_netrwPlugin = 1` from `settings.lua` (already in init.lua).

**Step 3: Remove duplicate filetype detection from settings.lua**

Remove `autocmd BufNewFile,BufRead *.mdx setfiletype markdown` from `settings.lua` (will be in settings or a single place).

**Step 4: Remove `vim.o.ttyfast = true` from performance.lua**

Not a valid Neovim option.

**Step 5: Fix the TextChanged large-file detection**

Replace the line-by-line iteration with `vim.api.nvim_buf_get_offset()`:
```lua
local buf_size = vim.api.nvim_buf_get_offset(buf, line_count)
```

**Step 6: Verify Neovim starts cleanly**

Run: `nvim --headless -c 'echo "OK" | qa'`

**Step 7: Commit**

```
refactor(settings): consolidate duplicate vim options into settings.lua
```

---

### Task 2: Clean up init.lua — remove duplicate built-in plugin disabling

**Files:**
- Modify: `init.lua`

**Step 1: Remove the manual `vim.g["loaded_" .. plugin]` loop (lines 5-37)**

Keep only lazy.nvim's `performance.rtp.disabled_plugins` (lines 72-76) since lazy.nvim handles this.

**Step 2: Move performance.setup() BEFORE lazy.setup()**

So that grepprg and autocmd settings are available before plugins initialize.

**Step 3: Verify Neovim starts cleanly**

Run: `nvim --headless -c 'echo "OK" | qa'`

**Step 4: Commit**

```
refactor(init): remove duplicate built-in plugin disabling, reorder loading
```

---

### Task 3: Re-enable treesitter

**Files:**
- Modify: `lua/plugins/nvim-treesitter.lua`
- Modify: `lua/plugins/nvim-treesitter-textobjects.lua`

**Step 1: Set `enabled = true` (or remove the line) in nvim-treesitter.lua**

**Step 2: Move filetype detections to settings.lua**

Move `*.avdl → java` and `*.mdx → markdown` autocmds from treesitter config to `settings.lua` using `vim.filetype.add()`:
```lua
vim.filetype.add({
  extension = {
    mdx = "markdown",
    avdl = "java",
  },
})
```

Remove the `vim.cmd("autocmd ...")` lines from treesitter config AND settings.lua.

**Step 3: Re-enable textobjects plugin**

Set `enabled = true` in `nvim-treesitter-textobjects.lua`.

**Step 4: Verify treesitter loads**

Run: `nvim --headless -c 'TSInstallSync lua | qa'` then open a .lua file and check `:TSBufToggle highlight`.

**Step 5: Commit**

```
feat(treesitter): re-enable treesitter with existing large-file guards
```

---

### Task 4: Re-enable nvim-lspconfig and consolidate LSP settings

**Files:**
- Modify: `lua/plugins/nvim-lspconfig.lua`
- Modify: `lua/plugins/mason-lspconfig.lua`
- Modify: `lua/plugins/lspsaga.lua`

**Step 1: Set `enabled = true` in nvim-lspconfig.lua**

**Step 2: Consolidate diagnostic config**

Remove the top-level `vim.diagnostic.config()` from `lspsaga.lua` (lines 1-12). Let `nvim-lspconfig.lua` be the single place for diagnostic config. Use the lspsaga-style virtual_text config:
```lua
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = '●',
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "single",
    source = "always",
    header = "",
    prefix = "",
    max_width = 80,
    max_height = 20,
  },
})
```

**Step 3: Remove the diagnostic handler override from mason-lspconfig.lua**

Delete lines 122-128 (`vim.lsp.handlers["textDocument/publishDiagnostics"]`) since nvim-lspconfig now handles this.

**Step 4: Fix deprecated API in nvim-lspconfig.lua**

Replace `vim.lsp.get_active_clients` with `vim.lsp.get_clients` (deprecated in Neovim 0.10+).

**Step 5: Verify LSP attaches**

Open a TypeScript file: `:LspInfo` should show vtsls attached.

**Step 6: Commit**

```
feat(lsp): re-enable nvim-lspconfig with consolidated diagnostic settings
```

---

### Task 5: Fix Telescope, conform, and nvim-cmp bugs

**Files:**
- Modify: `lua/plugins/telescope.lua`
- Modify: `lua/plugins/conform.lua`
- Modify: `lua/plugins/nvim-cmp.lua`

**Step 1: Remove `q` mapping from Telescope insert mode**

Delete `["q"] = actions.close` from the `i = {}` mappings block (keep it in `n = {}`).

**Step 2: Remove unused `trouble` import**

Delete line 15: `local trouble = require("telescope.actions.generate").open_in_trouble`

**Step 3: Fix conform formatters to use fallback (first-available) syntax**

Change from `{ "eslint", "prettierd" }` to `{ { "eslint", "prettierd" } }` for each filetype that has multiple formatters.

**Step 4: Disable ghost_text in nvim-cmp**

Set `ghost_text = false` in the experimental section.

**Step 5: Verify Telescope search works with letter q**

Open Telescope live_grep, type a query containing "q".

**Step 6: Commit**

```
fix(plugins): fix Telescope q-in-insert, conform fallback formatters, disable ghost_text
```

---

### Task 6: Fix typos and minor cleanup

**Files:**
- Modify: `lua/settings.lua`
- Modify: `lua/keymappings.lua`

**Step 1: Fix "Copilet" → "Copilot" typo**

In `settings.lua` line 43 and `keymappings.lua` line 71.

**Step 2: Verify no other issues**

Run: `nvim --headless -c 'echo "OK" | qa'`

**Step 3: Commit**

```
fix: correct Copilot typo in comments
```
