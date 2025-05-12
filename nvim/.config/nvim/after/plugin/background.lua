function setBackgroundTransparent()
	vim.api.nvim_set_hl(0, "Normal",{ bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat",{ bg = "none" })
	vim.api.nvim_set_hl(0, "FloatBorder",{ bg = "none" })
end
--setBackgroundTransparent()
--
--#region

-- vim.api.nvim_set_hl(0, "@typescriptBlock", { link = "Function" })
-- vim.api.nvim_set_hl(0, "@typescriptFuncCallArg", { link = "Identifier" })
-- vim.api.nvim_set_hl(0, "@typescriptProp", { link = "Property" })
