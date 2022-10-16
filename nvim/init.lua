-- In Lua, there are three types of config:
--  vim.api.nvim_set_option() — global options
-- vim.api.nvim_buf_set_option() — buffer-local options
-- vim.api.nvim_win_set_option() — window-local options
-- config files get required here
local cmd = vim.cmd -- alias to execute Vim commands, e.g cmd('pwd')
local fn = vim.fn -- alias to call Vim functions, e.g :fn.bufnr()
local g = vim.g -- alias to a table to access global variables

vim.g.mapleader = " "

require("settings")
require("fn")
require("plugins")
--vim.g.tokyonight_style = "night"
--cmd[[colorscheme tokyonight]] -- set color theme
--require('nightfox').load('nightfox')
cmd([[colorscheme catppuccin]])

local key_maps = {
	{ mode = "n", lhs = "<C-h>", rhs = ":wincmd h<CR>", opts = { noremap = true } },
	{ mode = "n", lhs = "<C-j>", rhs = ":wincmd j<CR>", opts = { noremap = true } },
	{ mode = "n", lhs = "<C-k>", rhs = ":wincmd k<CR>", opts = { noremap = true } },
	{ mode = "n", lhs = "<C-l>", rhs = ":wincmd l<CR>", opts = { noremap = true } },
	{ mode = "n", lhs = "<leader>c", rhs = ":bd <CR>", opts = { noremap = true } },
	{ mode = "n", lhs = "<C-p>", rhs = ":Telescope find_files<CR>", opts = { noremap = true } },
	{ mode = "n", lhs = "<leader>fb", rhs = ":Telescope buffers<CR>", opts = { noremap = true } },
	{ mode = "n", lhs = "<leader>fh", rhs = ":Telescope help_tags<CR>", opts = { noremap = true } },
	{ mode = "n", lhs = "<leader>fg", rhs = ":Telescope live_grep<CR>", opts = { noremap = true } },
	{ mode = "n", lhs = "<leader>mp", rhs = ":Telescope man_pages<CR>", opts = { noremap = true } },
}

-- TODO: move this into util file
-- re-use it for lang srv
local set_key = function(maps)
	for _, v in pairs(maps) do
		vim.api.nvim_set_keymap(v.mode, v.lhs, v.rhs, v.opts)
	end
end

set_key(key_maps)
cmd([[command! Bufs :buffers]])

-- Maps
-- vim.api.nvim_set_keymap(mode, lhs, rhs, options)
--vim.api.nvim_set_keymap('n', '<leader>h', ':wincmd h<CR>', {noremap = true})
--vim.api.nvim_set_keymap('n', '<leader>j', ':wincmd j<CR>', {noremap = true})
--vim.api.nvim_set_keymap('n', '<leader>k', ':wincmd k<CR>', {noremap = true})
--vim.api.nvim_set_keymap('n', '<leader>l', ':wincmd l<CR>', {noremap = true})
---- switch & delete buffers
--vim.api.nvim_set_keymap('n', '<leader><leader>', '<c-^>', {noremap = true})
--vim.api.nvim_set_keymap('n', '<leader>c', ':bd <CR>', {noremap = true})
--vim.api.nvim_set_keymap('n', '<C-p>', ":Telescope find_files<CR>", {noremap=true})
--vim.api.nvim_set_keymap('n', '<leader>b', ":Telescope buffers<CR>", {noremap=true})
--vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap=true})

require("lang-conf")
