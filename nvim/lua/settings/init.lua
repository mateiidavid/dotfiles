local global = require('settings.global_state')
local vim = vim

-- cache
local createdir = function()
  local data_dir = {
    global.cache_dir .. 'backup',
    global.cache_dir .. 'undo',
  }

  if vim.fn.isdirectory(global.cache_dir) == 0 then
    os.execute('mkdir -p ' .. global.cache_dir)
    for k, v in pairs(data_dir) do
      if vim.fn.isdirectry(v) == 0 then
        os.execute('mkdir -p ' .. v)
      end
    end
  end
end

local load_settings = function()
  createdir()
  require('settings.options').init()
  require('settings.keys').core_bindings()
end

local _set_local_opts = function(opts)
  return function()
    for k, v in pairs(opts) do
      vim.api.nvim_buf_set_options(0, k, v)
    end
  end
end

return {
  init = load_settings,
  mkfile_tabs = _set_local_opts({
    expandtab = false,
    softtabstop = 2,
    tabstop = 2,
    shiftwidth = 2,
  }),
}
