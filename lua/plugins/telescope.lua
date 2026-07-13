--------------------------------------------------------------------------------
--                 Telescope (nvim-telescope/telescope.nvim)                  --
--------------------------------------------------------------------------------

-- Enable native fuzzy finding (ripgrep)
pcall(require('telescope').load_extension, 'fzf')

-- Enable harpoon support
require('telescope').load_extension('harpoon')

local map = vim.keymap.set
map('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
map('n', '<leader><space>', require('telescope.builtin').find_files, { desc = '[ ] Search Files' })
map('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

map('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[F]ind [B]uffers' })
map('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
map('n', '<leader>fr', require('telescope.builtin').live_grep, { desc = '[F]ind by [R]g' })
map('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
map('n', '<leader>fd', require('telescope.builtin').marks, { desc = '[F]ind [M]arks' })
-- Git Keymaps
map('n', '<leader>gb', require('telescope.builtin').git_branches, { desc = '[G]it [B]ranches'})
map('n', '<leader>gs', require('telescope.builtin').git_status, { desc = '[G]it [S]tatus'})
map('n', '<leader>g$', require('telescope.builtin').git_files, { desc = '[G]it [$]tash ' })
map('n', '<leader>gvo', ':GBrowse<CR>', { desc = '[G]it [V]iew [O]rigin' })
map('n', '<leader>gvu', ':GBrowse @upstream<CR>', { desc = '[G]it [V]iew [U]pstream' })
map('v', '<leader>gvo', ':GBrowse<CR>', { desc = '[G]it [V]iew [O]rigin' })
map('v', '<leader>gvu', ':GBrowse @upstream<CR>', { desc = '[G]it [V]iew [U]pstream' })

-- Trouble integration
local trouble = require("trouble.providers.telescope")
-- require('telescope').setup {
--     defaults = {
--
--     }
-- }

-- Search in hidden files / directories (except .git)
local telescopeConfig = require("telescope.config")
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

require('telescope').setup({
	defaults = {
		-- `hidden = true` is not supported in text grep commands.
		vimgrep_arguments = vimgrep_arguments,
        mappings = {
            n = { ["<c-t>"] = require('trouble.sources.telescope').open },
            i = { ["<c-t>"] = require('trouble.sources.telescope').open },
        }
	},
	pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
	},
})

-- YAML Companion
require('telescope').load_extension('yaml_schema')
