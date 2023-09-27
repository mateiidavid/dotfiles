local utils = require('utils')

local M = {}

vim.g.mapleader = ' '

function M.core_bindings()
  utils.map_keys({
    { mode = 'n', lhs = '<C-h>', rhs = ':wincmd h<CR>', opts = { noremap = true } },
    { mode = 'n', lhs = '<C-j>', rhs = ':wincmd j<CR>', opts = { noremap = true } },
    { mode = 'n', lhs = '<C-k>', rhs = ':wincmd k<CR>', opts = { noremap = true } },
    { mode = 'n', lhs = '<C-l>', rhs = ':wincmd l<CR>', opts = { noremap = true } },
    { mode = 'n', lhs = '<leader>c', rhs = ':bd <CR>', opts = { noremap = true } },
    { mode = 'n', lhs = ';;', rhs = ':vert help quickref<CR>', opts = { noremap = true } },
  })
end
function M.telescope_bindings()
  utils.map_keys({
    { mode = 'n', lhs = '<C-p>', rhs = ':Telescope find_files<CR>', opts = { noremap = true } },
    { mode = 'n', lhs = '<leader>fb', rhs = ':Telescope buffers<CR>', opts = { noremap = true } },
    { mode = 'n', lhs = '<leader>fh', rhs = ':Telescope help_tags<CR>', opts = { noremap = true } },
    { mode = 'n', lhs = '<leader>fr', rhs = ':Telescope live_grep<CR>', opts = { noremap = true } },
    { mode = 'n', lhs = '<leader>mp', rhs = ':Telescope man_pages<CR>', opts = { noremap = true } },
  })
end

-- M.lsp_bindings() accepts a bufnr and sets up the bindings for the lsp
function M.lsp_bindings(bufnr)
  local opts = { noremap = true, silent = true }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local buf_keys = {
    { mode = 'n', lhs = 'gd', rhs = '<cmd>lua vim.lsp.buf.definition()<CR>', opts = opts },
    {
      mode = 'n',
      lhs = 'gh',
      rhs = "<cmd>lua require('lspsaga.provider').lsp_finder()<CR>",
      opts = opts,
    },
    {
      mode = 'n',
      lhs = 'gD',
      rhs = "<cmd>lua require('lspsaga.provider').preview_definition()<CR>",
      opts = opts,
    },
    { mode = 'n', lhs = 'K', rhs = '<cmd>lua vim.lsp.buf.hover()<CR>', opts = opts },
    { mode = 'n', lhs = 'gi', rhs = '<cmd>lua vim.lsp.buf.implementation()<CR>', opts = opts },
    {
      mode = 'n',
      lhs = 'gs',
      rhs = "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>",
      opts = opts,
    },
    { mode = 'n', lhs = '<space>e', rhs = '<cmd>lua vim.diagnostic.open_float()<CR>', opts = opts },
    { mode = 'n', lhs = '<C-k>', rhs = '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts = opts },
    {
      mode = 'n',
      lhs = '<space>wa',
      rhs = '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
      opts = opts,
    },
    {
      mode = 'n',
      lhs = '<space>wr',
      rhs = '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
      opts = opts,
    },
    {
      mode = 'n',
      lhs = '<space>wl',
      rhs = '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
      opts = opts,
    },
    {
      mode = 'n',
      lhs = '<space>D',
      rhs = '<cmd>lua vim.lsp.buf.type_definition()<CR>',
      opts = opts,
    },
    { mode = 'n', lhs = '<space>rn', rhs = '<cmd>lua vim.lsp.buf.rename()<CR>', opts = opts },
    { mode = 'n', lhs = '<space>a', rhs = '<cmd>lua vim.lsp.buf.code_action()<CR>', opts = opts },
    { mode = 'n', lhs = 'gr', rhs = '<cmd>lua vim.lsp.buf.references()<CR>', opts = opts },
    { mode = 'n', lhs = '[g', rhs = '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts = opts },
    { mode = 'n', lhs = ']g', rhs = '<cmd>lua vim.diagnostic.goto_next()<CR>', opts = opts },
    {
      mode = 'n',
      lhs = '<space>q',
      rhs = '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',
      opts = opts,
    },
    { mode = 'n', lhs = '<space>f', rhs = '<cmd>lua vim.lsp.buf.formatting()<CR>', opts = opts },
    {
      mode = 'n',
      lhs = '<space>l',
      rhs = "<cmd>lua require('lsp_lines').toggle()<CR>",
      opts = opts,
    },
    {
      mode = 'n',
      lhs = '<leader>hd',
      rhs = ':Gitsigns diffthis main<CR>',
      opts = opts,
    },
  }
  utils.buf_set_keymaps(bufnr, buf_keys)
end

return M
