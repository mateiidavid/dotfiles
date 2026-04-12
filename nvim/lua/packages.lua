local mk_final_packages = function(...)
    local final = {}
    for _, pack in ipairs({ ... }) do
        if pack.src then
            table.insert(final, pack)
        else
            vim.list_extend(final, pack)
        end
    end
    return final
end

local pack_colorschemes = {
    { src = 'https://github.com/vague2k/vague.nvim' },
    { src = 'https://github.com/sainnhe/sonokai' },
}

local pack_to_delete = {
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
}

local pack_treesitter = {
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
}

local pack_mini = {
    -- TODO:
    -- - add mini.files
    -- - add mini.statusline
    { src = 'https://github.com/echasnovski/mini-git' },
    { src = 'https://github.com/echasnovski/mini.diff' },
    { src = 'https://github.com/echasnovski/mini.icons' },
    { src = 'https://github.com/echasnovski/mini.jump2d' },
    { src = 'https://github.com/echasnovski/mini.pairs' },
    { src = 'https://github.com/echasnovski/mini.pick' },
}

vim.pack.add(mk_final_packages(pack_colorschemes, pack_to_delete, pack_mini, pack_treesitter, {
    { src = 'https://github.com/folke/which-key.nvim' },
    { src = 'https://github.com/windwp/nvim-autopairs' },
}))

require('which-key').setup({
    preset = 'helix',
})

require('mini.icons').setup()
require('mini.pick').setup()
require('mini.git').setup()
require('mini.pairs').setup()
require('mini.diff').setup({
    view = {
        style = vim.go.number and 'sign',
    },
})
require('mini.jump2d').setup({
    -- Jump to word beginnings (like Helix)
    spotter = require('mini.jump2d').gen_spotter.pattern('%f[%w]%w'),
    view = {
        dim = false,
    },
    mappings = {
        start_jumping = 'gW',
    },
})

-- Treesitter configuration
-- nvim-treesitter itself is managed via vim.pack (see pack_treesitter above);
-- parsers are installed to cache (Nix store is read-only).
local ts_parser_dir = vim.fn.expand('~/.cache/nvim/ts_parsers')
vim.opt.runtimepath:append(ts_parser_dir)

local ts_ok, ts_configs = pcall(require, 'nvim-treesitter.configs')
if not ts_ok then
    vim.notify('nvim-treesitter not available yet — restart neovim once download completes', vim.log.levels.WARN)
else
    ts_configs.setup({
        parser_install_dir = ts_parser_dir,
        ensure_installed = {
            'bash', 'c', 'json', 'kdl', 'lua', 'markdown', 'markdown_inline',
            'meson', 'nix', 'perl', 'python', 'rust', 'terraform', 'toml', 'yaml', 'zig',
        },
        sync_install = false,
        auto_install = false,
        ignore_install = {},
        modules = {},
        highlight = { enable = true },
        indent = { enable = true, disable = { 'nix' } },
    })
end

require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = 'seoul256',
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
