---
-- Plugins
---
require('lazy').setup({
    -- colorscheme
    {'dracula/vim', name = 'dracula'}, -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = true,
        event = "UIEnter",
        config = function() require('setup-plugins.treesitter') end
    }, {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = true,
        event = "UIEnter",
        dependencies = {"nvim-treesitter/nvim-treesitter"}
    }, -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        lazy = true,
        event = "UIEnter",
        dependencies = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
        config = function() require('setup-plugins.telescope') end
    }, -- Telescope plugins
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        lazy = true,
        event = "UIEnter",
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        dependencies = {'nvim-telescope/telescope.nvim'}
    }, -- File exporer
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {'nvim-tree/nvim-web-devicons'},
        priority = 100,
        -- lazy = true,
        -- event = "UIEnter",
        -- version = 'nightly',
        config = function() require('setup-plugins.nvim-tree') end
    }, {
        'nvim-lualine/lualine.nvim',
        lazy = true,
        event = "UIEnter",
        dependencies = {'nvim-tree/nvim-web-devicons'},
        config = function() require('setup-plugins.lualine') end
    }, 
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
    {'lewis6991/gitsigns.nvim', lazy = true, event = 'UIEnter', config = true},
    {
        'akinsho/git-conflict.nvim',
        lazy = true,
        event = "UIEnter",
        version = '*',
        opt = {
            {
                default_mappings = false, -- disable buffer local mapping created by this plugin
                default_commands = true, -- disable commands created by this plugin
                disable_diagnostics = true -- This will disable the diagnostics in a buffer whilst it is conflicted
            }
        },
        config = true
    }, -- utils
    {'Raimondi/delimitMate', lazy = true, event = "UIEnter"},
    {'tpope/vim-commentary', lazy = true, event = "UIEnter"},
    {'djoshea/vim-autoread', lazy = true, event = "UIEnter"}, {
        'gelguy/wilder.nvim',
        lazy = true,
        event = "UIEnter",
        config = function() require('setup-plugins.wilder') end
    }, {'jparise/vim-graphql', lazy = true, event = "UIEnter"},

    {'qpkorr/vim-bufkill', lazy = true, event = "UIEnter"}, {
        'ggandor/leap.nvim',
        lazy = true,
        event = "UIEnter",
        config = function() require('setup-plugins.leap') end
    }, {'tpope/vim-repeat', lazy = true, event = "UIEnter"},
    {'tpope/vim-surround', lazy = true, event = "UIEnter"},
    {'tpope/vim-sleuth', lazy = true, event = "UIEnter"},
    {'sbdchd/neoformat', lazy = true, event = "UIEnter"},
    {'Pocco81/HighStr.nvim', lazy = true, config = true, event = "UIEnter"}, {
        'iamcco/markdown-preview.nvim',
        lazy = true,
        event = "UIEnter",
        build = function() vim.fn['mkdp#util#install']() end
    }, -- search & replace
    {'windwp/nvim-spectre', lazy = true, event = "UIEnter"},
    {'windwp/nvim-autopairs', lazy = true, event = "UIEnter", config = true},
    {'jxnblk/vim-mdx-js', lazy = true}, {
        'goolord/alpha-nvim',
        dependencies = {'nvim-tree/nvim-web-devicons'},
        config = function() require('setup-plugins.alpha') end
    }, -- vscode-like icons in completion
    {
        'onsails/lspkind.nvim',
        lazy = true,
        event = "UIEnter",
        config = function() require('setup-plugins.lspkind') end
    }, -- LSP Autocompletion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- 'hrsh7th/cmp-cmdline', -- command line
            'hrsh7th/cmp-buffer', -- buffer completions
            'hrsh7th/cmp-nvim-lua', -- nvim config completions
            'hrsh7th/cmp-nvim-lsp', -- lsp completions
            'hrsh7th/cmp-path' -- file path completions
        },
        lazy = true,
        event = "UIEnter",
        config = function() require('setup-plugins.cmp') end
    }, -- Better rust support
    {
        'simrat39/rust-tools.nvim',
        lazy = true,
        dependencies = {'neovim/nvim-lspconfig'}
    }, -- LSP Support
    {'neovim/nvim-lspconfig', lazy = true, event = "UIEnter"}, {
        'williamboman/mason.nvim',
        lazy = true,
        event = "UIEnter",
        build = ':MasonUpdate',
        config = function() require('setup-plugins.mason') end
    }, {
        'williamboman/mason-lspconfig.nvim',
        lazy = true,
        event = "UIEnter",
        dependencies = {'williamboman/mason.nvim'},
        config = function() require('setup-plugins.mason-lspconfig') end
    }, {'b0o/schemastore.nvim', lazy = true, event = "UIEnter"}, {
        'glepnir/lspsaga.nvim',
        branch = 'main',
        dependencies = {
            {'williamboman/mason-lspconfig.nvim', 'neovim/nvim-lspconfig'}
        },
        lazy = true,
        event = 'UIEnter',
        config = function()
            require("lspsaga").setup({request_timeout = 5000})
        end
    }
}, {
    performance = {
        cache = {enabled = true},
        reset_packpath = true, -- reset the package path to improve startup time
        rtp = {
            reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
            paths = {}, -- add any custom paths here that you want to includes in the rtp
            disabled_plugins = {
                "gzip", "man", "matchit", "matchparen", "netrwPlugin",
                "tarPlugin", "tohtml", "tutor", "zipPlugin", "rplugin", "shada"
            }
        }
    }
})
