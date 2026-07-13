------------------------------------------------------------
-- Markdown settings
------------------------------------------------------------

vim.opt_local.wrap = true
vim.opt_local.linebreak = true

vim.opt_local.relativenumber = false

vim.cmd('Wrapwidth 120')

-- Navigate by display lines instead of physical lines
local opts = { buffer = true, silent = true }
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', opts)
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', opts)
vim.keymap.set({ 'n', 'v' }, '0', 'g0', opts)
vim.keymap.set({ 'n', 'v' }, '$', 'g$', opts)
