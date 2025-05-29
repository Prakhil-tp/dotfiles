local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Buffer-local toggle state
local disabled_buffers = {}

--- Check if formatting is enabled for a buffer
local function is_formatting_enabled(bufnr)
  return not disabled_buffers[bufnr]
end

--- Echo a user message
local function notify(msg, hl)
  vim.api.nvim_echo({ { msg, hl } }, false, {})
end

--- Setup auto formatting on save for a buffer
local function setup_format_on_save(bufnr)
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      if is_formatting_enabled(bufnr) then
        vim.lsp.buf.format({ bufnr = bufnr })
      end
    end,
  })
end

--- Toggle formatting for the current buffer
local function toggle_formatting()
  local bufnr = vim.api.nvim_get_current_buf()
  disabled_buffers[bufnr] = not disabled_buffers[bufnr]

  if disabled_buffers[bufnr] then
    notify("❌ Formatting disabled for this buffer", "WarningMsg")
  else
    notify("✅ Formatting enabled for this buffer", "MoreMsg")
  end
end

--- User command to toggle formatting
vim.api.nvim_create_user_command("NoFormatting", toggle_formatting, {})

--- Setup null-ls with Prettier and formatting hook
null_ls.setup({
  sources = {
    formatting.prettier.with({}),
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      disabled_buffers[bufnr] = false
      setup_format_on_save(bufnr)
    end
  end,
})
