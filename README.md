# Neovim Configuration

A performance-optimized Neovim configuration for TypeScript/JavaScript, Java, Go, Lua, Rust, Python, Swift, and Kotlin development. Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management with lazy-loading for fast startup.

**Leader key:** `\` (backslash)

## Plugin Overview

### Core

| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager with lazy-loading |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Multi-module utility (dashboard, notifications, bigfile, indent guides, etc.) |
| [dracula](https://github.com/Mofiqul/dracula.nvim) | Color scheme |

### Navigation & Search

| Plugin | Purpose |
|--------|---------|
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | Fuzzy finder (files, grep, buffers, git) |
| [flash.nvim](https://github.com/folke/flash.nvim) | Quick jump/motion with labels |
| [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) | File explorer (floating window) |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | Edit filesystem like a buffer |
| [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | Search and replace across files |

### LSP & Completion

| Plugin | Purpose |
|--------|---------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configuration |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/formatter/linter installer |
| [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim) | Bridge between mason and lspconfig |
| [blink.cmp](https://github.com/saghen/blink.cmp) | Autocompletion with Rust fuzzy matcher |
| [lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim) | LSP UI enhancements (hover, rename, finder) |
| [schemastore.nvim](https://github.com/b0o/schemastore.nvim) | JSON/YAML schema catalog |

### Syntax & Formatting

| Plugin | Purpose |
|--------|---------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting and indentation |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Code formatting |

### Editor Enhancements

| Plugin | Purpose |
|--------|---------|
| [copilot.lua](https://github.com/zbirenbaum/copilot.lua) | GitHub Copilot (disabled, using Claude Code) |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Add/change/delete surrounding pairs |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets and quotes |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Snippet collection |

### UI

| Plugin | Purpose |
|--------|---------|
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline (bubbles theme) |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer tabs |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File type icons |

### Git

| Plugin | Purpose |
|--------|---------|
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs in gutter, blame |

### LSP Servers (auto-installed via Mason)

- **vtsls** - TypeScript/JavaScript
- **jdtls** - Java
- **yamlls** - YAML
- **lua_ls** - Lua
- **eslint** - ESLint (auto-detects config presence)

## Key Mappings

### Fuzzy Finder (fzf-lua)

| Key | Action |
|-----|--------|
| `\sf` | Find files |
| `\ss` | Live grep (search text) |
| `\sb` | Search open buffers |
| `\sg` | Git status |
| `\sw` | Grep word under cursor |
| `\sh` | Help tags |
| `\sd` | Document diagnostics |
| `\sD` | Workspace diagnostics |
| `\sr` | Resume last search |
| `\sc` | Git commits |

Inside fzf-lua picker:
- `Ctrl-d` / `Ctrl-u` - Scroll preview
- `Ctrl-q` - Select all and send to quickfix

### LSP (via Lspsaga)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `K` | Hover documentation |
| `\rn` | Rename symbol |
| `\h` | Peek definition |
| `\gt` | Peek type definition |
| `\gr` | Find references (Lspsaga finder) |
| `\ca` | Code action |
| `\ge` | Buffer diagnostics |
| `\gE` | Workspace diagnostics |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Autocompletion (blink.cmp)

| Key | Action |
|-----|--------|
| `Tab` / `Ctrl-n` | Next completion item |
| `Shift-Tab` / `Ctrl-p` | Previous completion item |
| `Enter` | Accept completion |
| `Ctrl-Space` | Toggle completion / documentation |
| `Ctrl-e` | Dismiss completion |
| `Ctrl-d` | Scroll docs down |
| `Ctrl-f` | Scroll docs up |

### File Explorer

| Key | Action |
|-----|--------|
| `\wh` | Toggle NvimTree |
| `\ff` | Find current file in NvimTree |
| `-` | Open parent directory (Oil) |

### Buffer Management

| Key | Action |
|-----|--------|
| `\ww` | Close current buffer (preserves layout) |
| `Ctrl-n` | Next buffer |
| `Ctrl-p` | Previous buffer |

### Motion (flash.nvim)

| Key | Action |
|-----|--------|
| `s` | Flash jump (type chars to jump to) |
| `S` | Flash treesitter (select treesitter node) |
| `r` | Remote flash (operator-pending mode) |

### Search & Replace

| Key | Action |
|-----|--------|
| `\S` | Open search and replace (grug-far) |
| `\S` (visual) | Search selected text |

### Formatting

| Key | Action |
|-----|--------|
| `\fmt` | Format current file |
| `:Format` | Format with LSP |

### Git

| Key | Action |
|-----|--------|
| `\bb` | Git blame current line |
| `\gB` | Open file/repo in browser |

### Copilot (disabled, re-enable in `lua/plugins/copilot-lua.lua`)

| Key | Action |
|-----|--------|
| `Ctrl-J` | Accept Copilot suggestion |
| `Alt-]` | Next suggestion |
| `Alt-[` | Previous suggestion |
| `Ctrl-]` | Dismiss suggestion |

### Snacks.nvim Extras

| Key | Action |
|-----|--------|
| `]]` | Jump to next LSP reference |
| `[[` | Jump to previous LSP reference |
| `\nn` | Show notification history |

### General

| Key | Action |
|-----|--------|
| `\p` | Smart paste (disables syntax temporarily) |
| `<` / `>` (visual) | Indent and reselect |
| `Ctrl-h/j/k/l` | Arrow keys in insert/command mode |
| `gc` / `gcc` | Comment (built-in Neovim 0.10+) |
| `ys`/`ds`/`cs` | Surround add/delete/change |

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

## Commands

| Command | Action |
|---------|--------|
| `:Format` | Format file with LSP |
| `:ReloadConfig` | Reload Neovim configuration |
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP/tool installer |
| `:TSInstall <lang>` | Install treesitter parser (e.g., `:TSInstall go python`) |
| `:TSUpdate` | Update all treesitter parsers |
| `:GrugFar` | Open search and replace |
| `:Oil` | Open filesystem editor |
| `:Copilot` | Copilot status/commands (disabled) |

## Performance Features

- **Lazy-loading**: Plugins load on demand via events (`BufReadPost`, `InsertEnter`, `VeryLazy`)
- **Large file handling**: snacks.bigfile disables heavy features for files >256KB
- **LSP debouncing**: 150ms debounce on background LSP requests (definitions/references are instant)
- **Treesitter guards**: Skips highlighting for files >100KB or >5000 lines
- **Disabled built-in plugins**: 25+ unused Vim plugins disabled at startup
- **Optimized search**: Uses ripgrep (`rg`) for grep, fd for file finding
- **UI minimalism**: No cursor line, no ruler, no showcmd for faster rendering

## File Structure

```
~/.config/nvim/
  init.lua                          -- Entry point: lazy.nvim bootstrap, plugin loading
  lua/
    settings.lua                    -- All vim options (single source of truth)
    keymappings.lua                 -- Global key mappings
    performance.lua                 -- Runtime performance optimizations
    startup-profile.lua             -- Startup timing
    plugins/
      blink-cmp.lua                 -- Autocompletion
      bufferline.lua                -- Buffer tabs
      conform.lua                   -- Code formatting
      copilot-lua.lua               -- GitHub Copilot (disabled)
      dracula.lua                   -- Color scheme
      flash.lua                     -- Quick jump motions
      fzf-lua.lua                   -- Fuzzy finder
      gitsigns.lua                  -- Git integration
      grug-far.lua                  -- Search and replace
      lspsaga.lua                   -- LSP UI
      lualine.lua                   -- Status line
      mason.lua                     -- LSP installer
      mason-lspconfig.lua           -- Mason + LSP bridge
      nvim-autopairs.lua            -- Auto bracket pairs
      nvim-lspconfig.lua            -- LSP configuration
      nvim-surround.lua             -- Surround text objects
      nvim-tree.lua                 -- File explorer
      nvim-treesitter.lua           -- Syntax highlighting
      oil.lua                       -- Filesystem editing
      schemastore.lua               -- JSON/YAML schemas
      snacks.lua                    -- Multi-module utility
```

## Treesitter Parsers

Installed parsers: typescript, javascript, tsx, json, yaml, lua, vim, vimdoc, markdown, swift, kotlin, ecma, jsx

nvim-treesitter v1.0 requires the `tree-sitter` CLI to compile parsers. If `:TSInstall` hangs, compile manually:

```sh
# 1. Download grammar source
cd /tmp && curl -sL "https://github.com/<repo>/archive/<revision>.tar.gz" | tar xz

# 2. Compile (add --generate flag if no src/parser.c exists)
cd <extracted-dir>/<location> && tree-sitter build -o parser.so

# 3. Install
cp parser.so ~/.local/share/nvim/site/parser/<lang>.so
echo "<revision>" > ~/.local/share/nvim/site/parser-info/<lang>.revision
```

To find repo/revision for a language: `:lua print(vim.inspect(require("nvim-treesitter.parsers").<lang>))`

## Requirements

- Neovim >= 0.10
- [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) - for grep operations
- [fd](https://github.com/sharkdp/fd) - for file finding
- [fzf](https://github.com/junegunn/fzf) - for fuzzy finding
- [tree-sitter](https://github.com/tree-sitter/tree-sitter) CLI (`brew install tree-sitter-cli`) - for compiling parsers
- A [Nerd Font](https://www.nerdfonts.com/) - for icons
- Node.js - for LSP servers
