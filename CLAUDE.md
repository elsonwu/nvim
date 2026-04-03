# Neovim Config - Maintenance Guide

## Architecture

- **Purpose**: Code review workflow — file navigation, LSP go-to-definition, syntax highlighting
- **Plugin manager**: lazy.nvim with lazy-loading (event/cmd/keys triggers)
- **Settings**: Single source of truth in `lua/settings.lua` — do NOT duplicate vim options elsewhere
- **Diagnostics**: Consolidated in `lua/plugins/nvim-lspconfig.lua` — do NOT configure diagnostics in lspsaga or other plugins
- **Performance**: Runtime-only logic in `lua/performance.lua`, runs BEFORE lazy.nvim loads
- **Leader key**: `\` (backslash)
- **No completion engine**: LSP capabilities via `vim.lsp.protocol.make_client_capabilities()`

## Critical: nvim-treesitter v1.0 API

This config uses nvim-treesitter v1.0+ which has major breaking changes from pre-v1.0:

- `require("nvim-treesitter.configs")` was REMOVED — do NOT use it
- `require("nvim-treesitter").setup({})` only accepts `install_dir`, no `ensure_installed`
- `:TSInstall` and `:TSUpdate` commands were REMOVED — we re-add them in `nvim-treesitter.lua`
- Highlighting is enabled via `vim.treesitter.start(buf)`, not plugin config
- Indentation uses `vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"`

### Parser compilation

- Requires `tree-sitter-cli` (`brew install tree-sitter-cli`) — NOT the `tree-sitter` library
- `require("nvim-treesitter").install()` async can hang inside nvim — compile manually if needed
- Parsers install to `~/.local/share/nvim/site/parser/<lang>.so`
- Revision tracking in `~/.local/share/nvim/site/parser-info/<lang>.revision`
- Some grammars (e.g., swift) need `tree-sitter generate` before `tree-sitter build`
- Get parser info: `:lua print(vim.inspect(require("nvim-treesitter.parsers").<lang>))`

### Manual parser install

```sh
cd /tmp && curl -sL "https://github.com/<repo>/archive/<rev>.tar.gz" | tar xz
cd <extracted>/<location> && tree-sitter build -o parser.so
cp parser.so ~/.local/share/nvim/site/parser/<lang>.so
echo "<rev>" > ~/.local/share/nvim/site/parser-info/<lang>.revision
```

## ESLint LSP

- ESLint server uses `root_dir` detection — only starts in projects with ESLint config files
- Detects: `.eslintrc.*`, `eslint.config.*` (js/mjs/cjs)
- Will NOT start in projects without ESLint config (no "Unable to find ESLint library" warnings)

## Plugin conventions

- Each plugin has its own file in `lua/plugins/`
- lazy.nvim `cmd = {}` creates stub commands that trigger plugin load — use this for commands defined inside `config`
- Use `config = function() ... end` instead of `opts = {}` when the plugin module might not be installed yet (e.g., snacks.nvim)
- All autocmds inside plugin configs MUST use an augroup with `clear = true` to prevent accumulation on `:ReloadConfig`

## Removed plugins (history in git)

| Removed | Reason |
|---------|--------|
| blink.cmp, friendly-snippets | No completion needed for code review |
| conform.nvim | No formatting needed |
| nvim-autopairs | No coding |
| nvim-surround | No coding |
| grug-far.nvim | No search/replace needed |
| bufferline.nvim | fzf-lua buffers + C-n/C-p suffice |
| schemastore.nvim | No JSON schema editing |
| telescope, nvim-cmp, alpha-nvim, fidget, leap, copilot, vim-commentary, wilder, lspkind, nvim-spectre, nvim-treesitter-textobjects | Previously disabled, now deleted |

## Gotchas

- `lazy-lock.json`: If empty (0 bytes), delete it — causes "commit is nil" errors. lazy.nvim regenerates it on next startup
- `*.cloning` files in `~/.local/share/nvim/lazy/`: Lock files from interrupted installs — delete them before retrying
- Neovim 0.11 renamed `vim.treesitter.language.ft_to_lang` to `get_lang`
- `vim.o.ttyfast` is NOT a valid Neovim option — don't set it
- For buffer size checks, use `vim.api.nvim_buf_get_offset()` for O(1) instead of iterating lines
- `regexpengine = 0` (auto) is better than `1` (forced old engine)

## File locations

- Config source: `~/Library/Mobile Documents/com~apple~CloudDocs/Documents/Expedia Group/settings/config/nvim/`
- Symlinked to: `~/.config/nvim/`
- Plugin data: `~/.local/share/nvim/lazy/`
- Parser binaries: `~/.local/share/nvim/site/parser/`
- State/logs: `~/.local/state/nvim/`
- Git repo: `https://github.com/elsonwu/vim.git` (branch: `lsp`)

## Languages supported

TypeScript, JavaScript, TSX, JSON, YAML, Lua, Vim, Vimdoc, Markdown, Swift, Kotlin (treesitter parsers installed)

LSP servers (via Mason): vtsls (TS/JS), jdtls (Java), yamlls (YAML), lua_ls (Lua), eslint (auto-detect)
