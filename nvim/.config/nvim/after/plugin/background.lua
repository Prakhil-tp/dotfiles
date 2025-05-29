function setBackgroundTransparent()
  local transparent_groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    --telescope
    "TelescopeNormal",
    "TelescopeBorder",
    "TelescopePromptNormal",
    "TelescopePromptBorder",
    "TelescopeResultsNormal",
    "TelescopeResultsBorder",
    -- nvim-tree
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

-- setBackgroundTransparent()
