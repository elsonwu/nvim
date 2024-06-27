---
-- Plugins
---
require("lazy").setup({
	spec = {
		-- colorscheme
		{ "dracula/vim", lazy = false, name = "dracula" }, -- Treesitter
		{ "github/copilot.vim", event = "VeryLazy" },
		{ "j-hui/fidget.nvim", event = "BufEnter", lazy = true, opts = {} },
		{ "akinsho/toggleterm.nvim", event = "VeryLazy", version = "*", config = true },
		-- search & replace
		{ "windwp/nvim-spectre", event = "VeryLazy", config = true },
		{
			"nvim-treesitter/nvim-treesitter",
			event = "VeryLazy",
			build = ":TSUpdate",
			config = function()
				require("setup-plugins.treesitter")
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			event = "VeryLazy",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
		}, -- Telescope
		{
			"nvim-telescope/telescope.nvim",
			event = "VeryLazy",
			dependencies = {
				"nvim-lua/popup.nvim",
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
				-- "nvim-telescope/telescope-fzf-native.nvim", -- FZF sorter for Telescope
				"nvim-treesitter/nvim-treesitter", -- Treesitter for better syntax highlighting and code navigation
				-- "nvim-treesitter/playground", -- Treesitter playground for querying syntax trees
				"neovim/nvim-lspconfig", -- LSP configurations
				"hrsh7th/nvim-cmp", -- Autocompletion plugin
				"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
				-- "L3MON4D3/LuaSnip", -- Snippets plugin
				-- 'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
				-- "junegunn/fzf", -- FZF for fuzzy finding
				-- "junegunn/fzf.vim", -- FZF integration with Vim
				"nvim-telescope/telescope-node-modules.nvim",
				-- "Snikimonkd/telescope-git-conflicts.nvim",
				-- 'HUAHUAI23/telescope-dapzzzz',
				-- 'LukasPietzschmann/telescope-tabs',
				-- 'piersolenski/telescope-import.nvim',
			},
			config = function()
				require("setup-plugins.telescope")
			end,
		}, -- Telescope plugins
		{
			"nvim-tree/nvim-tree.lua",
			cmd = "NvimTreeToggle",
			event = "UIEnter",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("setup-plugins.nvim-tree")
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			event = "VeryLazy",
			dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
			config = function()
				require("setup-plugins.lualine")
			end,
		},
		{ "akinsho/bufferline.nvim", event = "VeryLazy", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
		-- git
		{ "aspeddro/gitui.nvim", event = "VeryLazy", config = true },
		{ "lewis6991/gitsigns.nvim", event = "VeryLazy", config = true },
		{
			"akinsho/git-conflict.nvim",
			version = "*",
			opt = {
				{
					default_mappings = false, -- disable buffer local mapping created by this plugin
					default_commands = true, -- disable commands created by this plugin
					disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
				},
			},
			ft = { "gitcommit", "gitrebase", "gitconfig" },
			config = true,
		}, -- utils
		{ "Raimondi/delimitMate", event = "VeryLazy" },
		{ "tpope/vim-commentary", event = "VeryLazy" },
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			config = function()
				require("which-key").setup({
					triggers = "",
				})
			end,
		},
		{ "djoshea/vim-autoread", event = "VeryLazy" },
		{
			"gelguy/wilder.nvim",
			event = "VeryLazy",
			config = function()
				require("setup-plugins.wilder")
			end,
		},
		{ "jparise/vim-graphql", event = "VeryLazy" },
		{ "qpkorr/vim-bufkill", event = "VeryLazy" },
		{
			"ggandor/leap.nvim",
			event = "VeryLazy",
			config = function()
				require("setup-plugins.leap")
			end,
		},
		{ "tpope/vim-repeat", event = "VeryLazy" },
		{ "tpope/vim-surround", event = "VeryLazy" },
		{ "tpope/vim-sleuth", event = "VeryLazy" },
		-- formatter
		{
			"stevearc/conform.nvim",
			event = "VeryLazy",
			opts = {},
			config = function()
				require("setup-plugins.conform")
			end,
		},
		-- { "Pocco81/HighStr.nvim" },
		{
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			ft = { "markdown" },
			build = function()
				vim.fn["mkdp#util#install"]()
			end,
		},
		{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
		{
			"goolord/alpha-nvim",
			event = "BufEnter",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("setup-plugins.alpha")
			end,
		}, -- vscode-like icons in completion
		{
			"onsails/lspkind.nvim",
			event = "VeryLazy",
			config = function()
				require("setup-plugins.lspkind")
			end,
		}, -- LSP Autocompletion
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				-- 'hrsh7th/cmp-cmdline', -- command line
				"hrsh7th/cmp-buffer", -- buffer completions
				"hrsh7th/cmp-nvim-lua", -- nvim config completions
				"hrsh7th/cmp-nvim-lsp", -- lsp completions
				"hrsh7th/cmp-path", -- file path completions
			},
			config = function()
				require("setup-plugins.cmp")
			end,
		}, -- Better rust support
		{ "simrat39/rust-tools.nvim", ft = "rust", dependencies = { "neovim/nvim-lspconfig" } }, -- LSP Support
		{ "neovim/nvim-lspconfig", event = "VeryLazy" },
		{
			"williamboman/mason.nvim",
			event = "VeryLazy",
			build = ":MasonUpdate",
			config = function()
				require("setup-plugins.mason")
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			event = "VeryLazy",
			dependencies = { "williamboman/mason.nvim" },
			config = function()
				require("setup-plugins.mason-lspconfig")
			end,
		},
		{ "b0o/schemastore.nvim" },
		{
			"glepnir/lspsaga.nvim",
			branch = "main",
			event = "VeryLazy",
			dependencies = {
				{ "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
			},
			config = function()
				require("lspsaga").setup({ request_timeout = 5000 })
			end,
		},
	},
}, {
	performance = {
		cache = { enabled = true },
		reset_packpath = true, -- reset the package path to improve startup time
		rtp = {
			reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
			paths = {}, -- add any custom paths here that you want to includes in the rtp
			disabled_plugins = {
				"gzip",
				"man",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				"rplugin",
				"shada",
			},
		},
	},
})
