vim.g.mapleader = " "

vim.opt.relativenumber = true
vim.opt.number = true

vim.keymap.set('n', 'gd', '<C-]>', { desc = 'Go to definition (ctags)' })
