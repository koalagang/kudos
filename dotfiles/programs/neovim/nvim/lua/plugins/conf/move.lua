require('move').setup()

local opts = { noremap = true, silent = true }

-- Normal-mode commands
vim.keymap.set('n', '<A-h>', '<cmd>MoveWord(-1)<cr>', opts)
vim.keymap.set('n', '<A-l>', '<cmd>MoveWord(1)<cr>', opts)
vim.keymap.set('n', '<A-j>', '<cmd>MoveLine(1)<cr>', opts)
vim.keymap.set('n', '<A-k>', '<cmd>MoveLine(-1)<cr>', opts)
-- Visual-mode commands
vim.keymap.set('v', '<A-h>', ':MoveHBlock(-1)<cr>', opts)
vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<cr>', opts)
vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<cr>', opts)
vim.keymap.set('v', '<A-l>', ':MoveHBlock(1)<cr>', opts)
