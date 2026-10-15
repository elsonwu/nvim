# Neovim Configuration

A lightweight, performance-optimized Neovim configuration for **code review**. Built with [lazy.nvim](https://github.com/folke/lazy.nvim) for fast startup and 11 carefully chosen plugins.

**Leader key:** `\` (backslash)

## Plugins

| Plugin | Purpose |
| -------- | --------- |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Dashboard, file explorer, notifications, bigfile handling, indent guides |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | Fuzzy finder (files, grep, buffers, git) |
| [flash.nvim](https://github.com/folke/flash.nvim) | Jump to any location by typing characters |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client (go-to-definition, hover, diagnostics) |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP server installer |
| [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim) | Bridge between mason and lspconfig |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting, indentation and folding |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs in gutter, blame |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [dracula](https://github.com/Mofiqul/dracula.nvim) | Color scheme |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File type icons |

### LSP Servers (auto-installed via Mason)

- **tsgo** — TypeScript/JavaScript (TypeScript 7 native preview)
- **jdtls** — Java (requires Java 21+)
- **yamlls** — YAML
- **lua_ls** — Lua
- **eslint** — ESLint (auto-detects config presence)

---

## Key Mappings

### Search: `\\` (files, content, both)

One picker for everything. The query is `name/text -- path`, both halves optional:

| You type | You get |
| --- | --- |
| *(nothing)* | Recent files: open buffers by last use, then old files (cwd only) |
| `ActionPanel` | Files whose path contains `ActionPanel` (best 50) first, then lines containing it |
| `-- vmc .tsx$ !test` | Files only: path contains `vmc`, ends in `.tsx`, doesn't contain `test` |
| `submit -- vmc .tsx$` | Same, restricted to those files: their names, then lines matching `submit` |

- **Left of ` -- `** matches both file paths (substring, case-insensitive) and file
  contents (rg regex, smart-case). It's a regex on the content side, so `.` means any
  character; `\.` for a literal dot.
- **Right of ` -- `** filters paths only, fzf `--exact` syntax: space-separated
  substrings that must all match, `!x` excludes, `^x` starts with, `x$` ends with,
  `a | b` either.

| Key | Action |
| ----- | -------- |
| `\\` | Open search (visual mode: search the selection) |
| `\sr` | Resume last search |
| `/` (in explorer) | Search scoped to the focused node's directory |

Inside the picker:

- `alt-i` — toggle including gitignored files (prompt shows `+ignored`)
- `alt-c` — toggle only files changed vs `HEAD`, plus untracked (prompt shows `changed`)
- `Enter` open · `Ctrl-v` / `Ctrl-s` / `Ctrl-t` vsplit / split / tab
- `Ctrl-d` / `Ctrl-u` — scroll preview
- `Ctrl-q` — select all and send to quickfix

The matching lives in `bin/search`, a plain shell script you can run on its own to see
exactly what the picker gets: `~/.config/nvim/bin/search -- 'submit -- vmc .tsx$'`.

### Navigating Files

| Key | Action |
| ----- | -------- |
| `\wh` | Open explorer at the git root, revealing the current file (snacks) |
| `Ctrl-^` | Back to the previous file (native) |
| `Ctrl-n` | Next buffer |
| `Ctrl-p` | Previous buffer |
| `\ww` | Close current buffer (preserves layout) |

### Understanding Code (LSP)

| Key | Action |
| ----- | -------- |
| `gr` | Everything about the symbol under the cursor, whatever it is, in one list (below) |
| `K` | Hover documentation |
| `Ctrl-o` / `Ctrl-i` | Jump back / forward, restoring the previous scroll position |
| `\rn` | Rename symbol |
| `\ca` | Code action |
| `\sd` | Document diagnostics (fzf-lua) |
| `\sD` | Workspace diagnostics (fzf-lua) |
| `[d` / `]d` | Previous / next diagnostic |

`gr` rows are labelled:

| Label | Meaning |
| --- | --- |
| `def` | Where it's defined |
| `impl` | Implementations (interface / abstract members) |
| `ref` | Every place it's used |
| `out` | Calls made from inside this function (empty for non-functions) |

The line under the cursor is left out, and a line already listed under an earlier label
isn't repeated (for a plain function the LSP reports its definition as its
"implementation" too). Incoming calls aren't a separate label: every call site is
already a `ref`.


### Jumping Within a File

| Key | Action |
| ----- | -------- |
| `s` | Flash jump — type characters to jump to any match |
| `S` | Flash treesitter — select treesitter node |
| `r` | Remote flash (operator-pending mode) |
| `]]` | Jump to next LSP reference |
| `[[` | Jump to previous LSP reference |

### Git Context

| Key | Action |
| ----- | -------- |
| `\bb` | Git blame current line |
| `\gB` | Open file/repo in browser |
| `\sg` | Git status (fzf-lua) |
| `\sc` | Git commits (fzf-lua) |

### General

| Key | Action |
| ----- | -------- |
| `\qq` | Quit all |
| `\p` | Smart paste (disables syntax temporarily for speed) |
| `\sh` | Help tags |
| `\nn` | Notification history |
| `<Esc>` | Clear search highlights |
| `<` / `>` (visual) | Indent and reselect |
| `Ctrl-h/j/k/l` | Arrow keys in insert/command mode |
| `gc` / `gcc` | Comment (built-in Neovim 0.10+) |

### Dashboard (on startup)

| Key | Action |
| ----- | -------- |
| `n` | New file |
| `f` | Search (recent files when empty) |
| `c` | Edit config |
| `L` | Open Lazy plugin manager |
| `q` | Quit |

---

## Commands

| Command | Action |
| --------- | -------- |
| `:Format` | Format file with LSP |
| `:ReloadConfig` | Reload Neovim configuration |
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP/tool installer |
| `:TSInstall <lang>` | Install treesitter parser |
| `:TSUpdate` | Update all treesitter parsers |

---

## Performance Features

- **Lazy-loading**: Plugins load on demand via events, commands, or keybindings
- **Large file handling**: snacks.bigfile disables heavy features for files >256KB
- **Treesitter guards**: Skips highlighting for files >100KB or >5000 lines
- **LSP guards**: Auto-detaches LSP for files >1MB
- **Disabled built-in plugins**: 25+ unused Vim plugins disabled at startup
- **Optimized search**: ripgrep for grep, fd for file finding
- **UI minimalism**: No cursor line, no ruler, no showcmd for faster rendering

---

## File Structure

```
~/.config/nvim/
  init.lua                          -- Entry point: lazy.nvim bootstrap
  bin/
    search                          -- Unified search backend (query parsing + fd/fzf/rg)
  lua/
    settings.lua                    -- All vim options (single source of truth)
    keymappings.lua                 -- Global key mappings
    search.lua                      -- Unified search picker (wraps bin/search)
    performance.lua                 -- Runtime performance optimizations
    startup-profile.lua             -- Startup timing
    plugins/
      dracula.lua                   -- Color scheme
      flash.lua                     -- Quick jump motions
      fzf-lua.lua                   -- Fuzzy finder
      gitsigns.lua                  -- Git integration
      lualine.lua                   -- Status line
      mason.lua                     -- LSP installer
      mason-lspconfig.lua           -- Mason + LSP bridge
      nvim-lspconfig.lua            -- LSP configuration
      nvim-treesitter.lua           -- Syntax highlighting
      snacks.lua                    -- Multi-module utility (explorer, dashboard, etc.)
```

---

## Treesitter Parsers

Installed: typescript, javascript, tsx, json, yaml, lua, vim, vimdoc, markdown, swift, kotlin

nvim-treesitter v1.0 requires the `tree-sitter` CLI to compile parsers. If `:TSInstall` hangs, compile manually:

```sh
cd /tmp && curl -sL "https://github.com/<repo>/archive/<revision>.tar.gz" | tar xz
cd <extracted-dir>/<location> && tree-sitter build -o parser.so
cp parser.so ~/.local/share/nvim/site/parser/<lang>.so
echo "<revision>" > ~/.local/share/nvim/site/parser-info/<lang>.revision
```

To find repo/revision for a language: `:lua print(vim.inspect(require("nvim-treesitter.parsers").<lang>))`

## Requirements

- Neovim >= 0.11
- [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) — for grep operations
- [fd](https://github.com/sharkdp/fd) — for file finding
- [fzf](https://github.com/junegunn/fzf) — for fuzzy finding
- [tree-sitter](https://github.com/tree-sitter/tree-sitter) CLI (`brew install tree-sitter-cli`) — for compiling parsers
- A [Nerd Font](https://www.nerdfonts.com/) — for icons
- Node.js — for LSP servers
- Java 21+ — for jdtls (Java LSP)
