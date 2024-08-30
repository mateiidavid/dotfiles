
local treesitter = {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
        ensure_installed = {
            'c',
            'rust',
            'yaml',
            'toml',
            'go',
            'lua',
            'bash',
            'html',
            'json',
            'haskell',
        },
        ignore_install = {},
        highlight = {
            enable = true,
        },
        autopairs = { enable = true },
    }
}



return {
    treesitter,
    {
        'windwp/nvim-autopairs',
        opts = {
            disable_filetype = { 'TelescopePrompt' },
        },
    },
    { 'ckipp01/stylua-nvim' },
    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'hrsh7th/cmp-cmdline'},
        {'hrsh7th/nvim-cmp'},
        {'saadparwaiz1/cmp_luasnip'},
      },
   },
   { 'neovim/nvim-lspconfig' },
}
