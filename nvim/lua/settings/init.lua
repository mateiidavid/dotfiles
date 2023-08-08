local global = require 'settings.global'
local vim = vim

-- cache
local createdir = function()
  local data_dir = {
    global.cache_dir..'backup',
    global.cache_dir..'undo',
  }

  if vim.fn.isdirectory(global.cache_dir) == 0 then
    os.execute("mkdir -p "..global.cache_dir)
    for k, v in pairs(data_dir) do
      if vim.fn.isdirectry(v) == 0 then
        os.execute("mkdir -p "..v)
      end
    end
  end
end

local load_settings = function()
  createdir()
  require('settings.options')
end

load_settings()
