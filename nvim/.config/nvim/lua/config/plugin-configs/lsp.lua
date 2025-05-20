-- Make sure you have these plugins installed:
-- * neovim/nvim-lspconfig (v1.8.0)
-- * hrsh7th/nvim-cmp
-- * hrsh7th/cmp-nvim-lsp
-- * L3MON4D3/LuaSnip
require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require('cmp')
local autoformat = vim.api.nvim_create_augroup("LspAutoFormatting", { clear = true })
local format_enabled = {}

cmp.setup({
  -- Completion sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },

  -- Snippet expansion (using LuaSnip)
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  -- Key mapping for navigating the completion menu
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item() -- Move to the next item in the list
      else
        fallback()             -- Insert a tab character if no suggestions
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item() -- Move to the previous item in the list
      else
        fallback()             -- Insert a tab character if no suggestions
      end
    end, { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete()
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


-- Format code on saving
local function format_on_save(bufnr)
  if format_enabled[bufnr] == nil then
    format_enabled[bufnr] = true -- default to enabled
  end

  if format_enabled[bufnr] then
    vim.lsp.buf.format({ async = false })
  end
end

-- LSP keybindings for specific languages
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local bufnr = event.buf
    local opts = { buffer = bufnr }

    -- Set indentation to 2 spaces for the buffer
    vim.bo[bufnr].tabstop = 2
    vim.bo[bufnr].shiftwidth = 2
    vim.bo[bufnr].softtabstop = 2
    vim.bo[bufnr].expandtab = true

    -- LSP keymaps
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({ async = true })<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

    -- Enable formatting on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = autoformat,
      buffer = bufnr,
      callback = function()
        format_on_save(bufnr)
      end,
    })
  end,
})

-- Command to disable formatting
vim.api.nvim_create_user_command("DisableFormatting", function()
  local bufnr = vim.api.nvim_get_current_buf()
  format_enabled[bufnr] = false
  vim.notify("Autoformatting disabled for buffer " .. bufnr)
end, {})

-- Command to enable formatting
vim.api.nvim_create_user_command("EnableFormatting", function()
  local bufnr = vim.api.nvim_get_current_buf()
  format_enabled[bufnr] = true
  vim.notify("Autoformatting enabled for buffer " .. bufnr)
end, {})


-- Diagnostic settings
vim.diagnostic.config({
  virtual_text     = false, -- keep the buffer clean
  underline        = true,  -- still underline the range in error
  signs            = true,  -- show ❗ in the sign column
  update_in_insert = false, -- don’t fire while typing
  float            = {      -- style of the popup we’ll invoke
    border = "rounded",
    focusable = false,
    source = "always",
  },
})

vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, { scope = "cursor" })
end, { desc = "Show Diagnostics Float" })


-- Language server setups
require('lspconfig').ts_ls.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

require('lspconfig').lua_ls.setup({
  settings = {
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
    },
  },
})
require('lspconfig').eslint.setup({
  on_attach = function(client)
    -- Disable formatting capability for eslint
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
})
