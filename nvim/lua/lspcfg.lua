local lspconfig = require('lspconfig')

-- dg_init() configures LSP diagnostics
-- default: disable virtual text and virtual lines
local function dg_init()
  vim.diagnostic.config({
    virtual_text = false,
    --virtual_lines = { only_current_line = true },
    virtual_lines = false,
  })

  vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      -- Enable underline, use default values
      underline = true,
      signs = {
        enable = true,
        priority = 20,
      },
      -- Disable a feature
      update_in_insert = false,
    })
end

-- cmp_init() will configure snippets and the completion engine
local function cmp_init()
  local luasnip = require('luasnip')
  local cmp = require('cmp')
  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_next_item(),
      ['<C-n>'] = cmp.mapping.select_prev_item(),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    }),
    completion = {
      autocomplete = false,
    },
  })
end

local function mk_lsp_cfg(mk_default, on_attach_fn, lsp_capabilities_fn)
  return {
    gopls = {
      cmd = { 'gopls', 'serve' },
      on_attach = on_attach_fn,
      capabilities = lsp_capabilities_fn,
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
      },
    },
    rust_analyzer = mk_default(),
    ccls = mk_default(),
    lua_ls = {
      on_attach = on_attach_fn,
      capabilities = lsp_capabilities_fn,
      commands = {
        Format = {
          function()
            require('stylua-nvim').format_file()
          end,
        },
      },
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    },
    bashls = mk_default(),
  }
end

local function lsp_init()
  local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
  local on_attach = function(_client, bufnr)
    require('mappings').lsp_bindings(bufnr)
    local buf_set_option = function(...)
      vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('textwidth', 80)

    -- Remove 't'? added 'q', 'j'
    buf_set_option('formatoptions', 'c' .. 'r' .. 'q' .. 'b' .. 'j')
  end
  local mk_default_lsp = function()
    return {
      on_attach = on_attach,
      capabilities = lsp_capabilities,
    }
  end
  local cfg = mk_lsp_cfg(mk_default_lsp, on_attach, lsp_capabilities)
  for k, v in pairs(cfg) do
    lspconfig[k].setup(v)
  end
end

local init = function()
  dg_init()
  cmp_init()
  lsp_init()
end

return {
  setup = init,
}
