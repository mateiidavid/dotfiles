local M = {}

-- map_keys(t: <table>) is a helper function that maps a table with given keymap
-- config globally.
-- t: {mode, lhs, rhs, opts = {}}
function M.map_keys(t)
    for _, v in pairs(t) do
        vim.api.nvim_set_keymap(v.mode, v.lhs, v.rhs, v.opts)
    end
end

function M.buf_set_keymaps(bufnr, t)
    local buf_set_keymap = function(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    for _, v in pairs(t) do
        buf_set_keymap(v.mode, v.lhs, v.rhs, v.opts)
    end
end

return M
