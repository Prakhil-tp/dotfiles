vim.keymap.set("n", "<C-e>", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-e>", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.cmd("stopinsert")
  end,
})
