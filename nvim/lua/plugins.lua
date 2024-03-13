local ensure_packer = function()
  local fn = vim.fn
  vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = 'Packer',
  pattern = '*/lua/*.lua',
  callback = function()
    vim.cmd('source <afile>')
    vim.cmd('PackerCompile')
  end,
})

-- //
-- // Plugin set-up
-- //
local function telescope_setup()
  require('mappings').telescope_bindings()
  require('telescope').setup({
    pickers = {
      buffers = {
        theme = 'ivy',
      },
      live_grep = {
        theme = 'dropdown',
      },
      help_tags = {
        theme = 'dropdown',
      },
      find_files = {
        theme = 'ivy',
      },
      man_pages = {
        theme = 'dropdown',
      },
    },
  })
end

local function treesitter_setup()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'c',
      'rust',
      'yaml',
      'toml',
      'go',
      'bash',
      'lua',
      'fish',
      'html',
      'json',
      'haskell',
    }, -- one
    -- of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = {}, -- List of parsers to ignore installing
    highlight = {
      enable = true, -- false will disable the whole extension
      --disable = { "c", "rust" },  -- list of language that will be disabled
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    },
    autopairs = { enable = true },
  })
end

local function lualine_setup()
  require('lualine').setup({
    options = {
      icons_enabled = true,
      theme = 'rose-pine',
      --theme = 'dracula',
      --theme = 'palenight',
      --theme = 'rose-pine-alt',
      --theme = 'auto',
      --theme = 'seoul256',
      --theme = 'codedark',
      --component_separators = { left = '', right = ''},
      component_separators = { left = ' ', right = ' ' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff' },
      lualine_c = {
        {
          'buffers',
          show_filename_only = false,
          hide_filename_extension = true,
          mode = 4,
          max_length = vim.o.columns * 2 / 3,
        },
        --[[
        {
          'filename',
          file_status = true,
          path = 1, -- 1 is relative, 2 is abs
          shorting_target = 50,
        },
        --]]
      },
      lualine_x = { 'diagnostics' },
      lualine_y = { 'encoding', 'fileformat', 'filetype' },
      lualine_z = { 'progress', 'location' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    --tabline = {},
    extensions = {},
  })
end

local function bufferline_setup()
  require('bufferline').setup({
    options = {
      mode = 'buffers',
      numbers = 'ordinal',
      color_icons = true,
      show_buffer_default_icon = true,
    },
  })
end

local function rosepine_setup()
  require('rose-pine').setup({
    dark_variant = 'main',
    groups = {
      background = 'base',
      background_nc = '_experimental_nc',
      panel = 'surface',
      panel_nc = 'base',
      border = 'highlight_med',
      comment = 'muted',
      link = 'iris',
      punctuation = 'subtle',

      error = 'love',
      hint = 'iris',
      info = 'foam',
      warn = 'gold',

      headings = {
        h1 = 'iris',
        h2 = 'foam',
        h3 = 'rose',
        h4 = 'gold',
        h5 = 'pine',
        h6 = 'foam',
      },

      -- or set all headings at once
      -- headings = 'subtle'
    },

    -- Change specific vim highlight groups
    -- https://github.com/rose-pine/neovim/wiki/Recipes
    highlight_groups = {
      ColorColumn = { bg = 'highlight_high' },

      -- Blend colours against the "base" background
      CursorLine = { bg = 'foam', blend = 10 },
      IncSearch = { bg = 'highlight_mid' },
      lCursor = { bg = 'gold' },
    },
  })
  vim.api.nvim_command('colorscheme rose-pine')
end

-- //
-- // Packer
-- //
return require('packer').startup(function(use)
  use('wbthomason/packer.nvim') -- packer can manage itself, better it autoupdates I guess

  --use('/home/matei/workspace/side-projects/blame.nvim')
  use('/home/matei/workspace/sandbox/nvim-plugins/jottylist')
  -- --- LSP Config --
  use('neovim/nvim-lspconfig') -- lspconfig
  use('simrat39/rust-tools.nvim')
  use({
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('gitsigns').setup()
    end,
  })

  use('L3MON4D3/LuaSnip')
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
      'saadparwaiz1/cmp_luasnip',
    },
  })
  use('ckipp01/stylua-nvim')
  -- --- Util ---
  use({
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = telescope_setup,
  })
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = treesitter_setup,
  })
  use({
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { 'TelescopePrompt' },
      })
    end,
  })

  -- --- Themes/UI ---
  use('EdenEast/nightfox.nvim')
  use('ayu-theme/ayu-vim')
  use('tpope/vim-fugitive')
  use('shaunsingh/moonlight.nvim')
  use('folke/tokyonight.nvim')
  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    -- not in use rn
    config = function() end,
  })
  use({
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
      --vim.g.catppuccin_flavour = 'macchiato' -- latte, frappe, macchiato, mocha
      --require('catppuccin').setup()
      --vim.api.nvim_command('colorscheme catppuccin')
    end,
  })

  use({
    'rebelot/kanagawa.nvim',
    as = 'kanagawa',
    config = function()
      require('kanagawa').setup({
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        --commentStyle = { italic = false },
        functionStyle = {},
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = true, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        theme = 'wave', -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = 'wave', -- try "dragon" !
          light = 'lotus',
        },
      })
      vim.api.nvim_command('colorscheme kanagawa')
    end,
  })

  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = lualine_setup,
  })

  use({
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    config = function()
      require('lsp_lines').setup()
    end,
  })

  -- Bufferline is a tabline plugin, disable for now
  --use({
  --'akinsho/bufferline.nvim',
  --tag = 'v2.*',
  --requires = 'kyazdani42/nvim-web-devicons',
  --config = bufferline_setup,
  --})
  --

  if packer_bootstrap then
    require('packer').sync()
  end
end)
