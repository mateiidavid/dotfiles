-- Utility for development
require('fn')
-- Load 'lazy'
-- N.B this includes core settings and bindings
require('settings.lazy')
-- Lsp configuration
require('lsp.lspcfg').setup()
-- Autocmds
require('settings.autocmds')
