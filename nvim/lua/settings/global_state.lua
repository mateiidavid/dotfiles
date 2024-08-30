-- Set up global cache and relevant paths
-- 
--   Global module holds some neovim configuration specific state,
--   more specifically file paths that point to utility storage spaces:
--   - Home directory
--   - Config (and modules) path
--   - And a cache directory

-- Module to export
local global = {}

local home = os.getenv("HOME")
local path_delim = '/'

function global:load_variables()
  self.vim_path = vim.fn.stdpath('config')
  self.modules_dir = self.vim_path..path_delim..'modules'
  self.path_delim = path_delim
  self.cache_dir = home..path_delim..'.cache'..path_delim..'nvim'..path_delim
  self.home = home
end

global:load_variables()

return global
