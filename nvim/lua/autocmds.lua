local format_external_safe = function(command)
    if not command or #command == 0 then
        return
    end

    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local bufnr = vim.api.nvim_get_current_buf()
    local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n')
    -- NOTE: can technically make this async but I don't see the benefit; better
    -- to just wait
    local process = vim.system(command, { stdin = content, text = true })
    local result = process:wait()

    vim.schedule(function()
        local status = result.code or 1
        local stdout = result.stdout
        local stderr = result.stderr
        if status == 0 and stdout and stdout:match('%S') then
            local new_lines = vim.split(result.stdout:gsub('\n$', ''), '\n')
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
            vim.api.nvim_win_set_cursor(0, cursor_pos)
            vim.cmd('noautocmd write')
            vim.notify("formatted code successfully with '" .. command[1] .. "'")
        elseif stderr then
            local msg = command[1] .. " failed with code '" .. status .. "', " .. stderr
            vim.notify_once(msg, vim.log.levels.ERROR)
        end
    end)
end

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.lua' },
    callback = function()
        local command = {
            'stylua',
            '--column-width=120',
            '--line-endings=Unix',
            '--indent-type=Spaces',
            '--quote-style=AutoPreferSingle',
            '-',
        }
        format_external_safe(command)
    end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.rs', '*.go', '*.c', '*.nix' },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.c' },
    callback = function()
        -- TODO: move to own formatting command
        -- local path = vim.api.nvim_buf_get_name(0)
        -- vim.fn.system('clang-format ' .. path .. ' -i')
        -- vim.cmd([[e!]])
    end,
})
