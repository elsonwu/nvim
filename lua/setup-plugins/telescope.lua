require('telescope').setup({
    file_ignore_patterns = {'node_modules', '.git'},
    pickers = {
        live_grep = {additional_args = function(opts) return {"--hidden"} end}
    },
    defaults = {
        initial_mode = 'insert',
        path_display = {'absolute'},
        wrap_results = true,
        layout_strategy = 'vertical',
        layout_config = {height = 0.95, width = 0.95},
        default_mappings = false,
        mappings = {
            i = {["<C-j>"] = require('telescope.actions').move_selection_next}
        }
    },
    extensions = {
        -- fzf = {
        --     fuzzy = true, -- false will only do exact matching
        --     override_generic_sorter = true, -- override the generic sorter
        --     override_file_sorter = true, -- override the file sorter
        --     case_mode = "smart_case" -- or "ignore_case" or "respect_case"
        -- }
        -- project = {
        --   base_dirs = {
        --     '~/www',
        --   },
        --   theme = "dropdown",
        --   order_by = "asc",
        --   search_by = "title",
        --   sync_with_nvim_tree = true, -- default false
        -- }
    }
})

-- require('telescope').load_extension('fzf')
-- require('telescope').load_extension('project')
-- require('telescope').load_extension('dap')

local keymap = vim.keymap.set
-- search + LSP
local builtin = require('telescope.builtin')
keymap('n', '<leader>sf',
       ':Telescope find_files find_command=rg,--smart-case,--ignore,--hidden,--files<CR>')
keymap('n', '<leader>ss', builtin.live_grep, {})
keymap('n', '<leader>sw', builtin.grep_string, {})
keymap('n', '<leader>sb', builtin.buffers, {})
keymap('n', '<leader>sm', builtin.marks, {})
-- search and replace current word
keymap('n', '<leader>sr',
       ":lua require('spectre').open_visual({select_word=true})<CR>", {})

keymap('n', 'gd', builtin.lsp_definitions, {silent = true})
keymap("n", "<leader>gk", "<cmd>Lspsaga peek_definition<CR>", {silent = true})
keymap('n', '<leader>gt', builtin.lsp_type_definitions, {silent = true})
keymap("n", "<leader>gr", "<cmd>Lspsaga finder<CR>", {silent = true})
keymap('n', '<leader>gi', builtin.lsp_implementations, {silent = true})
keymap("n", "<leader>gE", "<cmd>Lspsaga show_buf_diagnostics<CR>",
       {silent = true})
keymap("n", "<leader>ge", "<cmd>Lspsaga show_cursor_diagnostics<CR>",
       {silent = true})

