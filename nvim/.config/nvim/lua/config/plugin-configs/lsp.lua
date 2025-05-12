-- Make sure you have these plugins installed:
-- * neovim/nvim-lspconfig (v1.8.0)
-- * hrsh7th/nvim-cmp
-- * hrsh7th/cmp-nvim-lsp
-- * L3MON4D3/LuaSnip

local cmp = require('cmp')

cmp.setup({
  -- Completion sources
  sources = {
    { name = 'nvim_lsp' }, -- LSP source
  },

  -- Snippet expansion (using LuaSnip)
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  -- Key mapping for navigating the completion menu
  mapping = cmp.mapping.preset.insert({
    -- Tab: Cycle to the next completion item
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()  -- Move to the next item in the list
      else
        fallback()  -- Insert a tab character if no suggestions
      end
    end, { 'i', 's' }),

    -- Shift + Tab: Cycle to the previous completion item
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()  -- Move to the previous item in the list
      else
        fallback()  -- Insert a tab character if no suggestions
      end
    end, { 'i', 's' }),

    -- Enter: Confirm the selection (with select = true)
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),

  -- Other options can be added here
  completion = {
    completeopt = 'menu,menuone,noinsert', -- Make sure the menu is always visible
  },
})

-- Reserve space in the gutter for LSP diagnostics
vim.opt.signcolumn = 'yes'

-- Add borders to floating windows for LSP handlers
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'rounded' }
)

-- Add capabilities for `nvim-cmp` to `lspconfig`
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- LSP keybindings for specific languages
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf }

    -- LSP keymaps
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({ async = true })<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- Language server setups
require('lspconfig').ts_ls.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

require('lspconfig').lua_ls.setup({})
require('lspconfig').eslint.setup({})
