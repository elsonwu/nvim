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

### Navigating Files

| Key | Action |
| ----- | -------- |
| `\\` | Go to anything: files; prefix `$` buffers, `@` symbols in file, `#` workspace symbols |
| `\wh` | Open explorer at the git root, revealing the current file (snacks) |
| `\ff` | Find files under a directory (prompts first, with tab completion) |
| `\sf` | Find files (respects .gitignore) |
| `\SF` | Find ALL files (includes gitignored) |
| `\sb` | Search open buffers |
| `\so` | Recent files in the current directory |
| `Ctrl-^` | Back to the previous file (native) |
| `Ctrl-n` | Next buffer |
| `Ctrl-p` | Previous buffer |
| `\ww` | Close current buffer (preserves layout) |

### Searching Code

| Key | Action |
| ----- | -------- |
| `\ss` | Live grep (respects .gitignore) |
| `\sS` | Live grep ALL (includes gitignored) |
| `\sw` | Grep word under cursor (also works on a visual selection) |
| `\sP` | Live grep scoped to a directory, scope stays editable (see below) |
| `\sG` | Live grep only files changed vs `HEAD` |
| `\sr` | Resume last search |

Inside fzf-lua picker:

- `Ctrl-d` / `Ctrl-u` — Scroll preview
- `Ctrl-q` — Select all and send to quickfix
- `Ctrl-g` — Toggle rg-regex mode ↔ fzf-fuzzy mode. **Regex only works in rg mode**; if a
  pattern that should match suddenly stops matching, check you haven't toggled.

#### Scoping a search: the ` -- ` glob syntax

This is the equivalent of VSCode's "files to include/exclude" box. A live-grep query has
two halves separated by ` -- `:

```text
ActionPanel -- *.tsx !**/test/**
└─ rg regex ─┘ └──── path globs ────┘
```

The left half goes to ripgrep as a **regex** (`\bfoo\b`, `(a|b)`, `foo.*bar` all work; rg
uses Rust regex, so no lookaround or backreferences without `-P`). Each whitespace-separated
token on the right becomes an `--iglob` (case-insensitive), `!` negates.

**Globs here are more forgiving than raw ripgrep**, via a custom `rg_glob_fn` in
`lua/plugins/fzf-lua.lua`. Raw rg anchors a glob to the *entire basename* and ignores
directory components unless the glob contains `/`, so bare `Virtual*` means "filename starts
with Virtual" and silently matches nothing when you meant "path contains Virtual". A token
without `/` is therefore rewritten to a substring match:

| You type | Actual glob | Matches |
| --- | --- | --- |
| `Virtual` · `Virtual*` · `*Virtual` | `*Virtual*` | `VirtualCard.tsx`, `MyVirtualThing.tsx` |
| `.tsx` | `*.tsx*` | any filename containing `.tsx` |
| `!test` | `!*test*` | excludes filenames containing `test` |
| `{ts,tsx}` | `*{ts,tsx}*` | brace expansion is preserved |
| `**/api/**` | unchanged | files under any `api/` directory |
| `**/*.tsx` | unchanged | strict extension match, no trailing `*` |

**Escape hatch:** any token containing `/` is passed through verbatim. That is also how you
get strict anchoring back when the substring rewrite is too loose — write `**/*.tsx`, not
`*.tsx`.

#### `\sP` — pick a directory, keep it editable

`\sP` prompts for a directory (with tab completion, which fzf's query line does not have)
and then pre-fills it as a glob rather than setting the picker's `cwd`:

```text
\sP → "Grep in dir: lua/plugins" → query becomes:   ▐ -- lua/plugins/**
                                                   ↑ cursor lands here
```

The point of the glob over `cwd` is that `cwd` is fixed for the whole picker session, while
the glob half stays editable — widen to `**/api/**` or drop the scope entirely without
reopening. Three cases are handled differently:

| Chosen directory | Behaviour |
| --- | --- |
| Below `cwd` | Pre-filled as `<rel>/**`, editable |
| Equal to `cwd` | No glob at all (`fnamemodify(cwd, ":.")` returns `""`, and rg rejects `./**`) |
| Outside `cwd` | Falls back to setting `cwd` — rg matches globs against cwd-relative paths, so a relative glob cannot reach it. Scope is fixed for that session |

Two things that look incidental but are not:

- The `/**` suffix is required. A bare `--iglob 'src/foo'` matches only the directory entry
  itself and reports "No files were searched".
- The cursor jump uses `keymap.fzf.start = "+beginning-of-line"`. The leading `+` **appends**
  to fzf-lua's own `start:+transform:<reload_command>` bind (`core.lua:640`); fzf keeps only
  the last `--bind` for an event, so dropping the `+` silently breaks live reloading.

Since the keyword half starts empty, the first rg run has an empty pattern and matches every
line in scope — expect a burst of results before your first keystroke narrows it.

> **Gotcha:** when a glob matches zero files, `rg` exits 2 with "No files were searched" but
> fzf-lua only shows an empty list. "Bad glob" and "genuinely no matches" look identical.

The `rg_glob_fn` **must stay self-contained** — no upvalues, `require` everything inside the
function body. `live_grep` forces `multiprocess = 1` and ships the function to a headless
Neovim instance via `string.dump`, which drops upvalues. A version that captures a local
from the enclosing file works in-process and fails only in the headless path, so it looks
fine until you actually search.

### Understanding Code (LSP)

| Key | Action |
| ----- | -------- |
| `gd` | Go to definition |
| `K` | Hover documentation |
| `\h` | Peek definition (fzf-lua preview) |
| `\gt` | Peek type definition |
| `\gr` | Find all references (fzf-lua) |
| `\sy` | Workspace symbols — jump to a class/function by name |
| `Ctrl-o` / `Ctrl-i` | Jump back / forward, restoring the previous scroll position |
| `\rn` | Rename symbol |
| `\ca` | Code action |
| `\ge` | Buffer diagnostics |
| `\gE` | Workspace diagnostics |
| `\sd` | Document diagnostics (fzf-lua) |
| `\sD` | Workspace diagnostics (fzf-lua) |
| `[d` / `]d` | Previous / next diagnostic |

### Jumping Within a File

| Key | Action |
| ----- | -------- |
| `gs` | Flash jump — type characters to jump to any match |
| `gS` | Flash treesitter — select treesitter node |
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
| `f` | Find file |
| `g` | Live grep |
| `r` | Recent files |
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
  lua/
    settings.lua                    -- All vim options (single source of truth)
    keymappings.lua                 -- Global key mappings
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
