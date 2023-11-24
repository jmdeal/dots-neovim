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
map('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
map('n', '<leader>fr', require('telescope.builtin').live_grep, { desc = '[S]earch by [R]g' })
map('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- Git Keymaps
map('n', '<leader>gb', require('telescope.builtin').git_branches, { desc = '[G]it [B]ranches'})
map('n', '<leader>gs', require('telescope.builtin').git_status, { desc = '[G]it [S]tatus'})
map('n', '<leader>g$', require('telescope.builtin').git_files, { desc = '[G]it [$]tash ' })

-- Trouble integration
local trouble = require("trouble.providers.telescope")
require('telescope').setup {
    defaults = {
        mappnings = {
            n = { ["<c-t>"] = trouble.open_with_trouble },
            i = { ["<c-t>"] = trouble.open_with_trouble },
        }

    }
}

-- YAML Companion
require('telescope').load_extension('yaml_schema')
