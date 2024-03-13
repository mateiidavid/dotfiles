local global = require('settings.global')

local function bind_options(options)
  for k, v in pairs(options) do
    if v == true or v == false then
      vim.cmd('set ' .. k)
    else
      vim.cmd('set ' .. k .. '=' .. v)
    end
  end
end

local function load_options()
  local global_local = {
    termguicolors = true,
    mouse = 'a',
    hidden = true,
    magic = true, -- allows escaping chars
    encoding = 'utf-8',
    undodir = global.cache_dir .. 'undo/',
    clipboard = 'unnamedplus',
    swapfile = false,
    backup = false,
    smarttab = true,
    updatetime = 200,
    ignorecase = true,
    smartcase = true,
    infercase = true,
    incsearch = true,
    splitbelow = true,
    splitright = true,
    completeopt = 'menu,menuone,noselect', -- noinsert?
    scrolloff = 8,
    shortmess = 'aoOTIcF',
    previewheight = 12,
    diffopt = 'vertical,algorithm:patience,indent-heuristic,context:10',
    showtabline = 0, -- 0 is never, 2 is always,
    cursorline = true,
    grepprg = 'rg',
    --
  }

  local bufw_local = {
    undofile = true,
    expandtab = true, -- spaces, not tabs
    autoindent = true,
    smartindent = true,
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    number = true,
    relativenumber = true,
    colorcolumn = 100,
    signcolumn = 'yes',
  }

  for opt_name, opt_value in pairs(global_local) do
    vim.o[opt_name] = opt_value
  end

  bind_options(bufw_local)
end

return {
  init = load_options,
}
