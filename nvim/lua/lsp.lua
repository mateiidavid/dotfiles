-- Diagnostic configuration with nice visuals
vim.diagnostic.config({
    virtual_text = false, -- Disable inline text
    underline = true,
    signs = true,
    update_in_insert = false,
    severity_sort = true, -- Show errors before warnings
    float = {
        border = 'rounded', -- Rounded corners for float windows
        source = true, -- Show source (e.g., "eslint", "rust-analyzer")
        focusable = false,
        header = '',
        prefix = '',
        format = function(diagnostic)
            return string.format('%s (%s)', diagnostic.message, diagnostic.source)
        end,
    },
})

-- Show diagnostic float when you pause on a line with issues
vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
        -- local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
        -- if #line_diagnostics > 0 then
        --     vim.diagnostic.open_float(nil, { focus = false, close_events = { 'CursorMoved', 'InsertEnter' } })
        -- end

        local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
        local has_float = false
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_is_valid(winid) then
                local config = vim.api.nvim_win_get_config(winid)
                if config.relative ~= '' then
                    has_float = true
                    break
                end
            end
        end

        if not has_float and #line_diagnostics > 0 then
            vim.diagnostic.open_float(nil, { focus = false, close_events = { 'CursorMoved', 'InsertEnter' } })
        end
    end,
})

-- LSP attach callback with keybindings
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- Enable built-in completion
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Set textwidth
        vim.bo[bufnr].textwidth = 80

        -- Modify formatoptions: remove 't', add 'rb'
        vim.opt_local.formatoptions:remove('t') -- Don't auto-wrap normal text
        vim.opt_local.formatoptions:append('rb') -- Add comment leader + smart wrapping

        -- Core LSP keybindings
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        -- More explicit diagnostic navigation with auto-float
        vim.keymap.set('n', '[g', function()
            vim.diagnostic.jump({ count = -1 })
            -- Force show float after jump
            vim.schedule(function()
                vim.diagnostic.open_float(nil, { focus = false })
            end)
        end, opts)
        vim.keymap.set('n', ']g', function()
            vim.diagnostic.jump({ count = 1 })
            -- Force show float after jump
            vim.schedule(function()
                vim.diagnostic.open_float(nil, { focus = false })
            end)
        end, opts)
        -- Smart K: show diagnostic if on error line, otherwise LSP hover
        vim.keymap.set('n', '<leader>e', function()
            local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
            if #line_diagnostics > 0 then
                vim.diagnostic.open_float(nil, { focus = false, close_events = { 'CursorMoved', 'InsertEnter' } })
            end
        end, opts)
        vim.keymap.set('n', 'K', function()
            vim.lsp.buf.hover()
        end, opts)
    end,
})
-- Direct LSP server configurations
local enabled_language_servers = { 'lua_ls', 'nixd', 'clangd', 'rust_analyzer', 'zls' }
vim.lsp.enable(enabled_language_servers)
local override_language_server_configs = {
    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = {
                    library = vim.api.nvim_get_runtime_file('', true),
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
            },
        },
    },
    nixd = {
        settings = {
            nixd = {
                nixpkgs = {
                    expr = 'import <nixpkgs> { }',
                },
                formatting = {
                    -- command = { 'alejandra', '-q' }, -- or 'nixpkgs-fmt'
                    command = { 'nixpkgs-fmt' },
                },
            },
        },
    },
}

for name, conf in pairs(override_language_server_configs) do
    vim.lsp.config(name, conf)
end

-- Default limits (you can configure these)
vim.opt.undolevels = 1000 -- Max undo steps in memory
vim.opt.undoreload = 10000 -- Max lines for undo on buffer reload

-- These affect MEMORY usage, not the undo FILE size
-- The undo file itself can grow quite large with no automatic truncation
--

-- Smart completion system with Ctrl-Space triggering (common IDE pattern)
-- Trigger completion with <C-Space> in insert mode
vim.keymap.set('i', '<C-Space>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-n>' -- If menu already visible, go to next
    else
        return '<C-x><C-o>' -- Otherwise trigger LSP completion
    end
end, { expr = true, desc = 'Trigger/navigate completion' })

-- Tab and Shift-Tab for navigation when completion menu is visible
vim.keymap.set('i', '<Tab>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-n>' -- Next completion
    else
        return '<Tab>' -- Normal tab behavior
    end
end, { expr = true, desc = 'Next completion or tab' })

vim.keymap.set('i', '<S-Tab>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-p>' -- Previous completion
    else
        return '<S-Tab>' -- Normal shift-tab behavior
    end
end, { expr = true, desc = 'Previous completion or shift-tab' })

-- Enter to accept completion
vim.keymap.set('i', '<CR>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-y>' -- Accept selected completion
    else
        return require('mini.pairs').cr() -- Normal enter
    end
end, { expr = true, desc = 'Accept completion or enter' })

-- Escape to cancel completion
vim.keymap.set('i', '<Esc>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-e><Esc>' -- Cancel completion then escape
    else
        return '<Esc>' -- Normal escape
    end
end, { expr = true, desc = 'Cancel completion or escape' })
