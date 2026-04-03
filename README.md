# Neovim Configuration

A lightweight, performance-optimized Neovim configuration for **code review**. Built with [lazy.nvim](https://github.com/folke/lazy.nvim) for fast startup and 14 carefully chosen plugins.

**Leader key:** `\` (backslash)

## Plugins

| Plugin | Purpose |
|--------|---------|
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Dashboard, notifications, bigfile handling, indent guides |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | Fuzzy finder (files, grep, buffers, git) |
| [flash.nvim](https://github.com/folke/flash.nvim) | Jump to any location by typing characters |
| [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) | File explorer (floating window) |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | Edit filesystem like a buffer |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client (go-to-definition, hover, diagnostics) |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP server installer |
| [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim) | Bridge between mason and lspconfig |
| [lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim) | LSP UI (peek definition, finder, rename) |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting and indentation |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs in gutter, blame |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [dracula](https://github.com/Mofiqul/dracula.nvim) | Color scheme |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File type icons |

### LSP Servers (auto-installed via Mason)

- **vtsls** — TypeScript/JavaScript
- **jdtls** — Java
- **yamlls** — YAML
- **lua_ls** — Lua
- **eslint** — ESLint (auto-detects config presence)

---

## Key Mappings

### Navigating Files

| Key | Action |
|-----|--------|
| `\wh` | Toggle file tree (NvimTree) |
| `\ff` | Find current file in tree |
| `-` | Open parent directory (Oil) |
| `\sf` | Find files (respects .gitignore) |
| `\sF` | Find ALL files (includes gitignored) |
| `\sb` | Search open buffers |
| `Ctrl-n` | Next buffer |
| `Ctrl-p` | Previous buffer |
| `\ww` | Close current buffer (preserves layout) |

### Searching Code

| Key | Action |
|-----|--------|
| `\ss` | Live grep (respects .gitignore) |
| `\sS` | Live grep ALL (includes gitignored) |
| `\sw` | Grep word under cursor |
| `\sr` | Resume last search |

Inside fzf-lua picker:
- `Ctrl-d` / `Ctrl-u` — Scroll preview
- `Ctrl-q` — Select all and send to quickfix

### Understanding Code (LSP)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `K` | Hover documentation |
| `\h` | Peek definition (inline preview) |
| `\gt` | Peek type definition |
| `\gr` | Find references (Lspsaga finder) |
| `\rn` | Rename symbol |
| `\ca` | Code action |
| `\ge` | Buffer diagnostics |
| `\gE` | Workspace diagnostics |
| `\sd` | Document diagnostics (fzf-lua) |
| `\sD` | Workspace diagnostics (fzf-lua) |
| `[d` / `]d` | Previous / next diagnostic |

### Jumping Within a File

| Key | Action |
|-----|--------|
| `s` | Flash jump — type characters to jump to any match |
| `S` | Flash treesitter — select treesitter node |
| `r` | Remote flash (operator-pending mode) |
| `]]` | Jump to next LSP reference |
| `[[` | Jump to previous LSP reference |

### Git Context

| Key | Action |
|-----|--------|
| `\bb` | Git blame current line |
| `\gB` | Open file/repo in browser |
| `\sg` | Git status (fzf-lua) |
| `\sc` | Git commits (fzf-lua) |

### General

| Key | Action |
|-----|--------|
| `\p` | Smart paste (disables syntax temporarily for speed) |
| `\sh` | Help tags |
| `\nn` | Notification history |
| `<` / `>` (visual) | Indent and reselect |
| `Ctrl-h/j/k/l` | Arrow keys in insert/command mode |
| `gc` / `gcc` | Comment (built-in Neovim 0.10+) |

### Dashboard (on startup)

| Key | Action |
|-----|--------|
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
|---------|--------|
| `:Format` | Format file with LSP |
| `:ReloadConfig` | Reload Neovim configuration |
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP/tool installer |
| `:TSInstall <lang>` | Install treesitter parser |
| `:TSUpdate` | Update all treesitter parsers |
| `:Oil` | Open filesystem editor |

---

## Performance Features

- **Lazy-loading**: Plugins load on demand via events, commands, or keybindings
- **Large file handling**: snacks.bigfile disables heavy features for files >256KB
- **Treesitter guards**: Skips highlighting for files >100KB or >5000 lines
- **LSP guards**: Auto-detaches LSP for files >1MB
- **LSP debouncing**: 150ms debounce on background requests (definitions/references are instant)
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
      lspsaga.lua                   -- LSP UI
      lualine.lua                   -- Status line
      mason.lua                     -- LSP installer
      mason-lspconfig.lua           -- Mason + LSP bridge
      nvim-lspconfig.lua            -- LSP configuration
      nvim-tree.lua                 -- File explorer
      nvim-treesitter.lua           -- Syntax highlighting
      oil.lua                       -- Filesystem editing
      snacks.lua                    -- Multi-module utility
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

- Neovim >= 0.10
- [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) — for grep operations
- [fd](https://github.com/sharkdp/fd) — for file finding
- [fzf](https://github.com/junegunn/fzf) — for fuzzy finding
- [tree-sitter](https://github.com/tree-sitter/tree-sitter) CLI (`brew install tree-sitter-cli`) — for compiling parsers
- A [Nerd Font](https://www.nerdfonts.com/) — for icons
- Node.js — for LSP servers
