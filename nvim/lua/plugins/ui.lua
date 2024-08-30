-- === UTIL CTORS ===

local function telescope_setup()
  return {
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
  }
end

local function lualine_setup()
  return {
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
  }
end

return {
    { 
        "nvim-telescope/telescope.nvim", 
        opts = telescope_setup(),
        lazy = true,
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('settings.keys').telescope_bindings()
        end,
    },
    { 
        "lewis6991/gitsigns.nvim", 
        opts = {},
        lazy = false,
        dependencies = {
            {'nvim-lua/plenary.nvim'}
        },
    },
    {
        'nvim-lualine/lualine.nvim',
        lazy = false,
        opts = lualine_setup(),
        dependencies = {
            {'kyazdani42/nvim-web-devicons'}
        }
    },
    {
       'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
       lazy = true,
       opts = {},
    }

}
