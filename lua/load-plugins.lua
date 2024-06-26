---
-- Plugins
---
require("lazy").setup({
	defaults = {
		lazy = false,
	},
	spec = {
		-- colorscheme
		{ "dracula/vim", event = "UIEnter", name = "dracula" }, -- Treesitter
		{ "github/copilot.vim", event = "UIEnter" },
		{ "j-hui/fidget.nvim", priority=1, lazy = false, opts = {} },
		{ "akinsho/toggleterm.nvim", version = "*", config = true },
		-- search & replace
		{ "windwp/nvim-spectre", config = true },
		{
			"nvim-treesitter/nvim-treesitter",
			event = "BufReadPost",
			build = ":TSUpdate",
			config = function()
				require("setup-plugins.treesitter")
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
		}, -- Telescope
		{
			"nvim-telescope/telescope.nvim",
			lazy = true,
			event = "UIEnter",
			dependencies = {
				"nvim-lua/popup.nvim",
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
				"nvim-telescope/telescope-fzf-native.nvim", -- FZF sorter for Telescope
				"nvim-treesitter/nvim-treesitter", -- Treesitter for better syntax highlighting and code navigation
				"nvim-treesitter/playground", -- Treesitter playground for querying syntax trees
				"neovim/nvim-lspconfig", -- LSP configurations
				"hrsh7th/nvim-cmp", -- Autocompletion plugin
				"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
				"L3MON4D3/LuaSnip", -- Snippets plugin
				-- 'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
				"junegunn/fzf", -- FZF for fuzzy finding
				"junegunn/fzf.vim", -- FZF integration with Vim
				"nvim-telescope/telescope-node-modules.nvim",
				"Snikimonkd/telescope-git-conflicts.nvim",
				-- 'HUAHUAI23/telescope-dapzzzz',
				-- 'LukasPietzschmann/telescope-tabs',
				-- 'piersolenski/telescope-import.nvim',
			},
			config = function()
				require("setup-plugins.telescope")
			end,
		}, -- Telescope plugins
		-- {
		--     'nvim-telescope/telescope-fzf-native.nvim',
		--     build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
		--     dependencies = {'nvim-telescope/telescope.nvim'}
		-- }, -- File exporer
		{
			"nvim-tree/nvim-tree.lua",
			cmd = "NvimTreeToggle",
			event = "VimEnter",
			lazy = false,
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("setup-plugins.nvim-tree")
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			lazy = true,
			event = "UIEnter",
			-- event = 'VimEnter',
			dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
			config = function()
				require("setup-plugins.lualine")
			end,
		},
		{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
		{ "lewis6991/gitsigns.nvim", config = true },
		{
			"akinsho/git-conflict.nvim",
			version = "*",
			lazy = true,
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
		{ "Raimondi/delimitMate" },
		{ "tpope/vim-commentary" },
		{ "djoshea/vim-autoread", event = "BufRead" },
		{
			"gelguy/wilder.nvim",
			config = function()
				require("setup-plugins.wilder")
			end,
		},
		{ "jparise/vim-graphql" },
		{ "qpkorr/vim-bufkill" },
		{
			"ggandor/leap.nvim",
			config = function()
				require("setup-plugins.leap")
			end,
		},
		{ "tpope/vim-repeat" },
		{ "tpope/vim-surround" },
		{ "tpope/vim-sleuth" },
		-- {'mhartington/formatter.nvim', cmd = 'Format'},
		-- formatter
		{
			"stevearc/conform.nvim",
			-- keys = {
			-- 	{
			-- 		-- Customize or remove this keymap to your liking
			-- 		"<leader>fmt",
			-- 		function()
			-- 			require("conform").format({ async = true, lsp_format = "fallback" })
			-- 		end,
			-- 		mode = "",
			-- 		desc = "Format buffer",
			-- 	},
			-- },

			opts = {},
			config = function()
				require("setup-plugins.conform")
			end,
		},
		{ "Pocco81/HighStr.nvim" },
		{
			"iamcco/markdown-preview.nvim",
			build = function()
				vim.fn["mkdp#util#install"]()
			end,
		},
		{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
		{ "jxnblk/vim-mdx-js" },
		{
			"goolord/alpha-nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("setup-plugins.alpha")
			end,
		}, -- vscode-like icons in completion
		{
			"onsails/lspkind.nvim",
			lazy = true,
			event = "UIEnter",
			config = function()
				require("setup-plugins.lspkind")
			end,
		}, -- LSP Autocompletion
		{
			"hrsh7th/nvim-cmp",
			lazy = true,
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
		{ "simrat39/rust-tools.nvim", dependencies = { "neovim/nvim-lspconfig" } }, -- LSP Support
		{ "neovim/nvim-lspconfig" },
		{
			"williamboman/mason.nvim",
			build = ":MasonUpdate",
			config = function()
				require("setup-plugins.mason")
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "williamboman/mason.nvim" },
			config = function()
				require("setup-plugins.mason-lspconfig")
			end,
		},
		{ "b0o/schemastore.nvim" },
		{
			"glepnir/lspsaga.nvim",
			lazy = true,
			event = "UIEnter",
			branch = "main",
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
