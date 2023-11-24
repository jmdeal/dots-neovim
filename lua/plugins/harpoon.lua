--------------------------------------------------------------------------------
--                       Harpoon (ThePrimeagen/harpoon)                       --
--------------------------------------------------------------------------------

vim.keymap.set('n', '<leader>he', require('harpoon.ui').toggle_quick_menu, { desc = '[H]arpoon [E]dit'})
vim.keymap.set('n', '<leader>hm', require('harpoon.mark').add_file, { desc = '[H]arpoon [M]ark'})

require('telescope').load_extension('harpoon')
vim.keymap.set('n', '<leader>hh', ':Telescope harpoon marks<CR>', { desc = '[HH]arpoon!!!'})

for i, c in ipairs({'a', 's', 'd', 'f'}) do
    vim.keymap.set('n', '<leader>h'..c, function()
        require('harpoon.ui').nav_file(i)
    end, { desc = '[H]arpoon to file '..i})
end

-- TODO: Figure out how to apply this to go projects only (use git worktrees everywhere else)
require('harpoon').setup({
    global_settings = {
        mark_branch = true
    }
})

