-- global options --
vim.o.termguicolors = true
vim.o.mouse = 'a'
vim.o.encoding = 'utf-8'
vim.o.swapfile = false
vim.o.backup = false
vim.o.smarttab = true
vim.o.cursorline = true
vim.o.grepprg = 'rg'
vim.o.number = true
vim.o.relativenumber = true
vim.g.mapleader = ' '
vim.o.splitright = true
vim.o.splitbelow = true
-- impacts swap and CursorHold autocommand event; `ms`
vim.o.updatetime = 600
-- ignore case; next one overrides it when using uppercase
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cursorline = true
vim.opt.clipboard:append('unnamedplus')
vim.opt.winborder = 'rounded'
-- some other time, maybe vim.o.shortmess = ''
-- buffer local options -
-- very important settings
-- see :h usr_30.txt; this turns spaces into tabs
vim.opt.expandtab = true
-- disable tabs and use shiftwidth instead
vim.opt.softtabstop = -1
vim.opt.shiftwidth = 4
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '100'

-- Enable persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'

-- Enable backup files for safety
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup'

-- -- Keep swap files (helps with crash recovery)
-- vim.opt.swapfile = true

-- Basic editor settings
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.updatetime = 300

-- Find files: Ctrl-P
vim.keymap.set('n', '<C-p>', ':Pick files<CR>', { desc = 'Find files in current working dir' })
vim.keymap.set('n', '<leader>/', ':Pick grep_live<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>b', ':Pick buffers<CR>', { desc = 'Switch current buffers' })
vim.keymap.set('n', '<leader>?', ':Pick help<CR>', { desc = 'Find help page' })
vim.keymap.set('n', '[b', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', ']b', ':bnext<CR>', { desc = 'Next buffer' })

require('packages')
require('lsp')
require('autocmds')

-- Set colorscheme to sonokai
vim.cmd.colorscheme('sonokai')
