-- === UTIL CTORs ===

local rosepine_setup = function()
  return {
    dark_variant = 'moon', -- when auto is used, theme changes depending on vim.o.background
    dim_inactive_windows = true,

    groups = {
      border = 'muted',
      link = 'iris',
      panel = 'surface',

      error = 'love',
      hint = 'iris',
      info = 'foam',
      note = 'pine',
      todo = 'rose',
      warn = 'gold',

      git_add = 'foam',
      git_change = 'rose',
      git_delete = 'love',
      git_dirty = 'rose',
      git_ignore = 'muted',
      git_merge = 'iris',
      git_rename = 'pine',
      git_stage = 'iris',
      git_text = 'rose',
      git_untracked = 'subtle',

      h1 = 'iris',
      h2 = 'foam',
      h3 = 'rose',
      h4 = 'gold',
      h5 = 'pine',
      h6 = 'foam',
    },

    enable = {
      terminal = true,
      legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
      migrations = true, -- Handle deprecated options automatically
    },

    styles = {
      bold = true,
      italic = true,
      transparency = false,
    },

    highlight_groups = {
      -- Comment = { fg = "foam" },
      -- VertSplit = { fg = "muted", bg = "muted" },
    },

    before_highlight = function(group, highlight, palette)
      -- Disable all undercurls
      -- if highlight.undercurl then
      --     highlight.undercurl = false
      -- end
      --
      -- Change palette colour
      -- if highlight.fg == palette.pine then
      --     highlight.fg = palette.foam
      -- end
    end,

    -- Change specific vim highlight groups
    -- https://github.com/rose-pine/neovim/wiki/Recipes
    --highlight_groups = {
    -- ColorColumn = { bg = 'highlight_high' },

    -- Blend colours against the "base" background
    --CursorLine = { bg = 'foam', blend = 10 },
    --IncSearch = { bg = 'highlight_mid' },
    --lCursor = { bg = 'gold' },
    --},
  }
end
-- === THEMES ===

local rosepine = {
    'rose-pine/neovim',
    lazy = false,
    priority = 1000,
    opts = rosepine_setup(),
    config = function()
        vim.api.nvim_command('colorscheme rosepine')
    end
}

local catppuccin = {
    "catppuccin/nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.api.nvim_command('colorscheme catppuccin')
    end,
}

local kanagawa = {
    "rebelot/kanagawa.nvim",
    lazy = false, 
    priority = 1000, 
    opts = {
      compile = false,
      undercurl = true,
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
      }
    },
    config = function()
      -- load the colorscheme here
      vim.api.nvim_command('colorscheme kanagawa')
    end,
}


return {
  -- the colorscheme should be available when starting Neovim
  kanagawa
}
