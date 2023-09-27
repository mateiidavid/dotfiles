require('settings')
require('fn')
require('plugins')
require('mappings').core_bindings()
--vim.g.tokyonight_style = "night"
--cmd[[colorscheme tokyonight]] -- set color theme
--require('nightfox').load('nightfox')
--cmd([[colorscheme catppuccin]])

--vim.cmd([[command! Bufs :buffers]])
vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '*.lua' }, command = ':Format' })
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*.rs', '*.go', '*.c' },
  callback = function()
    vim.lsp.buf.formatting_sync()
  end,
})

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  pattern = { '*.c' },
  callback = function()
    local path = vim.api.nvim_buf_get_name(0)
    vim.fn.system('clang-format ' .. path .. ' -i')
    vim.cmd([[e!]])
  end,
})
require('lspcfg').setup()
