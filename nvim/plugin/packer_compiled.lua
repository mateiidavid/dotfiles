-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/matei/.cache/nvim/packer_hererocks/2.1.1720049189/share/lua/5.1/?.lua;/home/matei/.cache/nvim/packer_hererocks/2.1.1720049189/share/lua/5.1/?/init.lua;/home/matei/.cache/nvim/packer_hererocks/2.1.1720049189/lib/luarocks/rocks-5.1/?.lua;/home/matei/.cache/nvim/packer_hererocks/2.1.1720049189/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/matei/.cache/nvim/packer_hererocks/2.1.1720049189/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["ayu-vim"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/ayu-vim",
    url = "https://github.com/ayu-theme/ayu-vim"
  },
  catppuccin = {
    config = { "\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0" },
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/catppuccin",
    url = "https://github.com/catppuccin/nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  kanagawa = {
    config = { "\27LJ\2\nÞ\2\0\0\4\0\f\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\0025\3\5\0=\3\6\0025\3\a\0=\3\b\0024\3\0\0=\3\t\0025\3\n\0=\3\v\2B\0\2\1K\0\1\0\15background\1\0\2\nlight\nlotus\tdark\twave\14typeStyle\19statementStyle\1\0\1\tbold\2\17keywordStyle\1\0\1\vitalic\1\18functionStyle\1\0\v\19terminalColors\2\fcompile\1\14undercurl\2\18functionStyle\0\17keywordStyle\0\19statementStyle\0\14typeStyle\0\16dimInactive\2\15background\0\16transparent\1\ntheme\twave\nsetup\rkanagawa\frequire\0" },
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/kanagawa",
    url = "https://github.com/rebelot/kanagawa.nvim"
  },
  ["lsp_lines.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14lsp_lines\frequire\0" },
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/lsp_lines.nvim",
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\nÂ\a\0\0\a\0\"\00256\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\t\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0=\4\a\0034\4\0\0=\4\b\3=\3\n\0025\3\f\0005\4\v\0=\4\r\0035\4\14\0=\4\15\0034\4\3\0005\5\16\0006\6\17\0009\6\18\0069\6\19\6\24\6\0\6\25\6\1\6=\6\20\5>\5\1\4=\4\21\0035\4\22\0=\4\23\0035\4\24\0=\4\25\0035\4\26\0=\4\27\3=\3\28\0025\3\29\0004\4\0\0=\4\r\0034\4\0\0=\4\15\0035\4\30\0=\4\21\0035\4\31\0=\4\23\0034\4\0\0=\4\25\0034\4\0\0=\4\27\3=\3 \0024\3\0\0=\3!\2B\0\2\1K\0\1\0\15extensions\22inactive_sections\1\2\0\0\rlocation\1\2\0\0\rfilename\1\0\6\14lualine_c\0\14lualine_z\0\14lualine_x\0\14lualine_a\0\14lualine_b\0\14lualine_y\0\rsections\14lualine_z\1\3\0\0\rprogress\rlocation\14lualine_y\1\4\0\0\rencoding\15fileformat\rfiletype\14lualine_x\1\2\0\0\16diagnostics\14lualine_c\15max_length\fcolumns\6o\bvim\1\2\4\0\fbuffers\tmode\3\4\15max_length\0\23show_filename_only\1\28hide_filename_extension\2\14lualine_b\1\3\0\0\vbranch\tdiff\14lualine_a\1\0\6\14lualine_c\0\14lualine_z\0\14lualine_x\0\14lualine_a\0\14lualine_b\0\14lualine_y\0\1\2\0\0\tmode\foptions\1\0\3\rsections\0\22inactive_sections\0\foptions\0\23disabled_filetypes\23section_separators\1\0\2\nright\bî‚²\tleft\bî‚°\25component_separators\1\0\2\nright\6 \tleft\6 \1\0\6\23disabled_filetypes\0\17globalstatus\2\25component_separators\0\25always_divide_middle\2\18icons_enabled\2\ntheme\14rose-pine\nsetup\flualine\frequire\4\6\0" },
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["moonlight.nvim"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/moonlight.nvim",
    url = "https://github.com/shaunsingh/moonlight.nvim"
  },
  ["nightfox.nvim"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/nightfox.nvim",
    url = "https://github.com/EdenEast/nightfox.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n‚\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\21disable_filetype\1\0\1\21disable_filetype\0\1\2\0\0\20TelescopePrompt\nsetup\19nvim-autopairs\frequire\0" },
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n”\2\0\0\4\0\v\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0024\3\0\0=\3\6\0025\3\a\0=\3\b\0025\3\t\0=\3\n\2B\0\2\1K\0\1\0\14autopairs\1\0\1\venable\2\14highlight\1\0\1\venable\2\19ignore_install\21ensure_installed\1\0\3\14highlight\0\19ignore_install\0\14autopairs\0\1\f\0\0\6c\trust\tyaml\ttoml\ago\tbash\blua\tfish\thtml\tjson\fhaskell\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rose-pine"] = {
    config = { "\27LJ\2\n\v\0\3\3\0\0\0\1K\0\1\0\5\1\0\4\0\17\0\0226\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\0024\3\0\0=\3\n\0023\3\v\0=\3\f\2B\0\2\0016\0\r\0009\0\14\0009\0\15\0'\2\16\0B\0\2\1K\0\1\0\26colorscheme rose-pine\17nvim_command\bapi\bvim\21before_highlight\0\21highlight_groups\vstyles\1\0\3\vitalic\2\17transparency\1\tbold\2\venable\1\0\3\rterminal\2\22legacy_highlights\2\15migrations\2\vgroups\1\0\25\15git_delete\tlove\nerror\tlove\tinfo\tfoam\15git_ignore\nmuted\15git_rename\tpine\14git_stage\tiris\rgit_text\trose\twarn\tgold\18git_untracked\vsubtle\ah1\tiris\ah2\tfoam\ah3\trose\ah4\tgold\ah6\tfoam\npanel\fsurface\thint\tiris\ah5\tpine\tnote\tpine\ttodo\trose\14git_merge\tiris\14git_dirty\trose\fgit_add\tfoam\15git_change\trose\vborder\nmuted\tlink\tiris\1\0\4\venable\0\25dim_inactive_windows\2\21before_highlight\0\17dark_variant\tmoon\nsetup\14rose-pine\frequire\0" },
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/rose-pine",
    url = "https://github.com/rose-pine/neovim"
  },
  ["rust-tools.nvim"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["stylua-nvim"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/stylua-nvim",
    url = "https://github.com/ckipp01/stylua-nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\né\2\0\0\5\0\18\0\0246\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\4\0005\2\16\0005\3\6\0005\4\5\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\0035\4\14\0=\4\15\3=\3\17\2B\0\2\1K\0\1\0\fpickers\1\0\1\fpickers\0\14man_pages\1\0\1\ntheme\rdropdown\15find_files\1\0\1\ntheme\bivy\14help_tags\1\0\1\ntheme\rdropdown\14live_grep\1\0\1\ntheme\rdropdown\fbuffers\1\0\5\14man_pages\0\fbuffers\0\14live_grep\0\14help_tags\0\15find_files\0\1\0\1\ntheme\bivy\nsetup\14telescope\23telescope_bindings\rmappings\frequire\0" },
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/matei/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: kanagawa
time([[Config for kanagawa]], true)
try_loadstring("\27LJ\2\nÞ\2\0\0\4\0\f\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\0025\3\5\0=\3\6\0025\3\a\0=\3\b\0024\3\0\0=\3\t\0025\3\n\0=\3\v\2B\0\2\1K\0\1\0\15background\1\0\2\nlight\nlotus\tdark\twave\14typeStyle\19statementStyle\1\0\1\tbold\2\17keywordStyle\1\0\1\vitalic\1\18functionStyle\1\0\v\19terminalColors\2\fcompile\1\14undercurl\2\18functionStyle\0\17keywordStyle\0\19statementStyle\0\14typeStyle\0\16dimInactive\2\15background\0\16transparent\1\ntheme\twave\nsetup\rkanagawa\frequire\0", "config", "kanagawa")
time([[Config for kanagawa]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\né\2\0\0\5\0\18\0\0246\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\4\0005\2\16\0005\3\6\0005\4\5\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\0035\4\14\0=\4\15\3=\3\17\2B\0\2\1K\0\1\0\fpickers\1\0\1\fpickers\0\14man_pages\1\0\1\ntheme\rdropdown\15find_files\1\0\1\ntheme\bivy\14help_tags\1\0\1\ntheme\rdropdown\14live_grep\1\0\1\ntheme\rdropdown\fbuffers\1\0\5\14man_pages\0\fbuffers\0\14live_grep\0\14help_tags\0\15find_files\0\1\0\1\ntheme\bivy\nsetup\14telescope\23telescope_bindings\rmappings\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n”\2\0\0\4\0\v\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0024\3\0\0=\3\6\0025\3\a\0=\3\b\0025\3\t\0=\3\n\2B\0\2\1K\0\1\0\14autopairs\1\0\1\venable\2\14highlight\1\0\1\venable\2\19ignore_install\21ensure_installed\1\0\3\14highlight\0\19ignore_install\0\14autopairs\0\1\f\0\0\6c\trust\tyaml\ttoml\ago\tbash\blua\tfish\thtml\tjson\fhaskell\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\n‚\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\21disable_filetype\1\0\1\21disable_filetype\0\1\2\0\0\20TelescopePrompt\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: rose-pine
time([[Config for rose-pine]], true)
try_loadstring("\27LJ\2\n\v\0\3\3\0\0\0\1K\0\1\0\5\1\0\4\0\17\0\0226\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\0024\3\0\0=\3\n\0023\3\v\0=\3\f\2B\0\2\0016\0\r\0009\0\14\0009\0\15\0'\2\16\0B\0\2\1K\0\1\0\26colorscheme rose-pine\17nvim_command\bapi\bvim\21before_highlight\0\21highlight_groups\vstyles\1\0\3\vitalic\2\17transparency\1\tbold\2\venable\1\0\3\rterminal\2\22legacy_highlights\2\15migrations\2\vgroups\1\0\25\15git_delete\tlove\nerror\tlove\tinfo\tfoam\15git_ignore\nmuted\15git_rename\tpine\14git_stage\tiris\rgit_text\trose\twarn\tgold\18git_untracked\vsubtle\ah1\tiris\ah2\tfoam\ah3\trose\ah4\tgold\ah6\tfoam\npanel\fsurface\thint\tiris\ah5\tpine\tnote\tpine\ttodo\trose\14git_merge\tiris\14git_dirty\trose\fgit_add\tfoam\15git_change\trose\vborder\nmuted\tlink\tiris\1\0\4\venable\0\25dim_inactive_windows\2\21before_highlight\0\17dark_variant\tmoon\nsetup\14rose-pine\frequire\0", "config", "rose-pine")
time([[Config for rose-pine]], false)
-- Config for: lsp_lines.nvim
time([[Config for lsp_lines.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14lsp_lines\frequire\0", "config", "lsp_lines.nvim")
time([[Config for lsp_lines.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\nÂ\a\0\0\a\0\"\00256\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\t\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0=\4\a\0034\4\0\0=\4\b\3=\3\n\0025\3\f\0005\4\v\0=\4\r\0035\4\14\0=\4\15\0034\4\3\0005\5\16\0006\6\17\0009\6\18\0069\6\19\6\24\6\0\6\25\6\1\6=\6\20\5>\5\1\4=\4\21\0035\4\22\0=\4\23\0035\4\24\0=\4\25\0035\4\26\0=\4\27\3=\3\28\0025\3\29\0004\4\0\0=\4\r\0034\4\0\0=\4\15\0035\4\30\0=\4\21\0035\4\31\0=\4\23\0034\4\0\0=\4\25\0034\4\0\0=\4\27\3=\3 \0024\3\0\0=\3!\2B\0\2\1K\0\1\0\15extensions\22inactive_sections\1\2\0\0\rlocation\1\2\0\0\rfilename\1\0\6\14lualine_c\0\14lualine_z\0\14lualine_x\0\14lualine_a\0\14lualine_b\0\14lualine_y\0\rsections\14lualine_z\1\3\0\0\rprogress\rlocation\14lualine_y\1\4\0\0\rencoding\15fileformat\rfiletype\14lualine_x\1\2\0\0\16diagnostics\14lualine_c\15max_length\fcolumns\6o\bvim\1\2\4\0\fbuffers\tmode\3\4\15max_length\0\23show_filename_only\1\28hide_filename_extension\2\14lualine_b\1\3\0\0\vbranch\tdiff\14lualine_a\1\0\6\14lualine_c\0\14lualine_z\0\14lualine_x\0\14lualine_a\0\14lualine_b\0\14lualine_y\0\1\2\0\0\tmode\foptions\1\0\3\rsections\0\22inactive_sections\0\foptions\0\23disabled_filetypes\23section_separators\1\0\2\nright\bî‚²\tleft\bî‚°\25component_separators\1\0\2\nright\6 \tleft\6 \1\0\6\23disabled_filetypes\0\17globalstatus\2\25component_separators\0\25always_divide_middle\2\18icons_enabled\2\ntheme\14rose-pine\nsetup\flualine\frequire\4\6\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: catppuccin
time([[Config for catppuccin]], true)
try_loadstring("\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0", "config", "catppuccin")
time([[Config for catppuccin]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
