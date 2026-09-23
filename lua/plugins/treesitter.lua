--------------------------------------------------------------------------------
--                Treesitter (nvim-treesitter/nvim-treesitter)                --
--------------------------------------------------------------------------------
--
-- Migrated to the `main` branch rewrite. The old `nvim-treesitter.configs`
-- module and its `.setup{}` table (highlight/indent/incremental_selection/
-- textobjects) no longer exist. Instead:
--   * parsers are installed via `require('nvim-treesitter').install{}`
--   * highlighting is Neovim-native, enabled per-buffer with `vim.treesitter.start()`
--   * indent is opt-in via `indentexpr`
--   * textobjects live in the separate `main`-branch plugin with explicit keymaps

local ts = require('nvim-treesitter')

-- Parsers to keep installed. `install` is async and a no-op for already-installed
-- parsers, so it is cheap to call on every startup.
local ensure_installed = {
    'c', 'cpp', 'go', 'rust', 'python', 'lua', 'vimdoc', 'vim', 'yaml', 'json', 'toml',
}
ts.install(ensure_installed)

-- Enable native Treesitter highlighting (and experimental indent) per filetype.
-- We map our parser names to filetypes; `vim.treesitter.start()` picks the parser
-- for the buffer's language automatically.
local ts_filetypes = {
    'c', 'cpp', 'go', 'rust', 'python', 'lua', 'help', 'vim', 'yaml', 'json', 'toml',
}
vim.api.nvim_create_autocmd('FileType', {
    pattern = ts_filetypes,
    callback = function()
        -- Highlighting (native, provided by Neovim).
        pcall(vim.treesitter.start)
        -- Indentation (experimental, provided by nvim-treesitter).
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

--------------------------------------------------------------------------------
--                              Text objects                                  --
--------------------------------------------------------------------------------

require('nvim-treesitter-textobjects').setup{
    select = {
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
    },
    move = {
        set_jumps = true, -- Set jumps in the jumplist
    },
}

local select = require('nvim-treesitter-textobjects.select')
local move = require('nvim-treesitter-textobjects.move')
local swap = require('nvim-treesitter-textobjects.swap')

-- select ----------------------------------------------------------------------
local select_maps = {
    ['aa'] = '@parameter.outer',
    ['ia'] = '@parameter.inner',
    ['af'] = '@function.outer',
    ['if'] = '@function.inner',
    ['ac'] = '@class.outer',
    ['ic'] = '@class.inner',
}
for lhs, query in pairs(select_maps) do
    vim.keymap.set({ 'x', 'o' }, lhs, function()
        select.select_textobject(query, 'textobjects')
    end)
end

-- move ------------------------------------------------------------------------
local move_maps = {
    goto_next_start = { [']m'] = '@function.outer', [']]'] = '@class.outer' },
    goto_next_end = { [']M'] = '@function.outer', [']['] = '@class.outer' },
    goto_previous_start = { ['[m'] = '@function.outer', ['[['] = '@class.outer' },
    goto_previous_end = { ['[M'] = '@function.outer', ['[]'] = '@class.outer' },
}
for fn, maps in pairs(move_maps) do
    for lhs, query in pairs(maps) do
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
            move[fn](query, 'textobjects')
        end)
    end
end

-- swap ------------------------------------------------------------------------
vim.keymap.set('n', '<leader>a', function()
    swap.swap_next('@parameter.inner')
end)
vim.keymap.set('n', '<leader>A', function()
    swap.swap_previous('@parameter.inner')
end)
