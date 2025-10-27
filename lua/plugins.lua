-- Bootstrap lazy.nvim on new machines
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    'tpope/vim-surround',
    'towolf/vim-helm',

    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'leoluz/nvim-dap-go',
            'rcarriga/nvim-dap-ui',
            'nvim-neotest/nvim-nio',
        },
        config = function()
            local dap = require 'dap'
            local ui = require 'dapui'

            ui.setup()
            require('dap-go').setup()

            -- TODO: determine why leader is still resolved as \ here
            vim.keymap.set('n', '<space>db', dap.toggle_breakpoint, {
                desc = '[D]ebug [B]reakpoint',
            })
            vim.keymap.set('n', '<space>dg', dap.run_to_cursor, {
                desc = '[D]ebug [G]oto Cursor',
            })
            vim.keymap.set('n', '<F1>', dap.continue, {
                desc = 'Debug Continue',
            })
            vim.keymap.set('n', '<F2>', dap.step_over, {
                desc = 'Debug Step Over',
            })
            vim.keymap.set('n', '<F3>', dap.step_into, {
                desc = 'Debug Step Into',
            })
            vim.keymap.set('n', '<F4>', dap.step_out, {
                desc = 'Debug Step Out',
            })
            vim.keymap.set('n', '<F9>', dap.restart, {
                desc = 'Debug Restart',
            })
            vim.keymap.set('n', '<F10>', dap.stop, {
                desc = 'Debug Stop',
            })
            vim.keymap.set('n', '<F12>', dap.disconnect, {
                desc = 'Debug Disconnect'
            })

            vim.keymap.set('n', '<space>dk', function()
                require('dapui').eval(nil, { enter = true })
            end, {
                desc = '[D]ebug Hover'
            })
            vim.keymap.set('n', '<space>dv', function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.scopes, { border = 'rounded' })
            end, {
                desc = '[D]ebug [V]ariables'
            })

            -- -- Configure the UI to open and close automatically
            -- dap.listeners.before.attach.dapui_config = function()
            --     ui.open()
            -- end
            -- dap.listeners.before.launch.dapui_config = function()
            --     ui.open()
            -- end
            -- dap.listeners.before.event_terminated.dapui_config = function()
            --     ui.close()
            -- end
            -- dap.listeners.before.event_exited.dapui_config = function()
            --     ui.close()
            -- end
        end
    },

    {
        'mrjones2014/smart-splits.nvim',
        lazy = false,
        config = function()
            require('smart-splits').setup({
                disable_multiplexer_nav_when_zoomed = false,
            })
            -- recommended mappings
            -- resizing splits
            -- these keymaps will also accept a range,
            -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
            vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
            vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
            vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
            vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
            -- moving between splits
            vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
            vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
            vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
            vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
            vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
            -- swapping buffers between windows
            vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
            vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
            vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
            vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)
        end
    },

    -- TODO: Themes
    'shaunsingh/nord.nvim',
    'navarasu/onedark.nvim',
    {
        'loctvl842/monokai-pro.nvim',
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('monokai-pro')
            require("monokai-pro").setup({
                transparent_background = true,
                background_clear = {
                    -- "float_win",
                    "toggleterm",
                    "telescope",
                    -- "which-key",
                    "renamer",
                    "notify",
                    -- "nvim-tree",
                    -- "neo-tree",
                    "bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
                },
            })
        end
    },
    {
        'ellisonleao/gruvbox.nvim',
        -- priority = 1000,
        -- config = function()
        --     vim.opt.background = "dark"
        --     vim.cmd.colorscheme 'gruvbox'
        -- end,
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            {
                'williamboman/mason.nvim',
                config = true,
                -- Pinned to v1.11.0 because setup_handlers was removed in v2.0.0, breaking config
                version = 'v1.11.0',
            },
            {
                'williamboman/mason-lspconfig.nvim',
                version = 'v1.11.0',
            },
            -- Some useful LSP status updates
            { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

            'folke/neodev.nvim',

            -- YAML schema selection
            'someone-stole-my-name/yaml-companion.nvim',
        },
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
        },
    },

    -- Git gutter stuffs
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See :help gitsigns.txt
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            -- TODO: move keybinds to keybind file
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
                    { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
                vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
                    { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
                vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
                    { buffer = bufnr, desc = '[P]review [H]unk' })
            end,
        },
    },

    { 'nvim-lualine/lualine.nvim', opts = { theme = 'monokai-pro' } },

    -- Indentation guides
    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        main = "ibl",
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = {
            indent = { char = '┊' },
            whitespace = {
                remove_blankline_trail = true,
            }
        },
    },

    { 'numToStr/Comment.nvim',     opts = {} },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
    },

    -- Treesitter: Better text highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },

    -- TODO Highlighting
    {
        'folke/todo-comments.nvim',
        opts = {
            highlight = {
                keyword = "bg",
                max_line_len = 2000,
            },
        },
    },

    -- Diagnostics Window
    'folke/trouble.nvim',

    -- Autopairs for brackets and braces
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {},
    },

    'kyazdani42/nvim-web-devicons',

    {
        'ThePrimeagen/harpoon',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
    },
    {
        'ggandor/leap.nvim',
        enabled = true,
        dependencies = {
            'tpope/vim-repeat',
        },
        keys = {
            { 's',  mode = { 'n', 'x', 'o' }, desc = 'Leap forward to' },
            { 'S',  mode = { 'n', 'x', 'o' }, desc = 'Leap backward to' },
            { 'gs', mode = { 'n', 'x', 'o' }, desc = 'Leap from windows' },
        },
        config = function(_, opts)
            local leap = require('leap')
            for k, v in pairs(opts) do
                leap.opts[k] = v
            end
            leap.add_default_mappings(true)
            vim.keymap.del({ 'x', 'o' }, 'x')
            vim.keymap.del({ 'x', 'o' }, 'X')
        end,
    },

    -- Seamless tmux navigation
    -- {
    --     'christoomey/vim-tmux-navigator',
    --     cmd = {
    --         'TmuxNavigateLeft',
    --         'TmuxNavigateDown',
    --         'TmuxNavigateUp',
    --         'TmuxNavigateRight',
    --         'TmuxNavigatePrevious',
    --     },
    --     keys = {
    --         { '<c-h>',  '<cmd><C-U>TmuxNavigateLeft<cr>' },
    --         { '<c-j>',  '<cmd><C-U>TmuxNavigateDown<cr>' },
    --         { '<c-k>',  '<cmd><C-U>TmuxNavigateUp<cr>' },
    --         { '<c-l>',  '<cmd><C-U>TmuxNavigateRight<cr>' },
    --         { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    --     },
    -- },
}, {})
