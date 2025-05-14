-- function setBackgroundTransparent()
--   vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--   vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--   vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
-- end
--
-- setBackgroundTransparent()


function setBackgroundTransparent()
  local transparent_groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "TelescopeNormal",
    "TelescopeBorder",
    "TelescopePromptNormal",
    "TelescopePromptBorder",
    "TelescopeResultsNormal",
    "TelescopeResultsBorder",
    "NvimTreeNormal",
    "NvimTreeNormalNC",
    "NvimTreeEndOfBuffer",
    "NvimTreeVertSplit",
    "NvimTreeWinSeparator",
  }

  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

setBackgroundTransparent()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setBackgroundTransparent,
})
