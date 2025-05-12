vim.g.vimwiki_folding = ""
vim.g.vimwiki_list = {
  {
    path = "~/documents/notes",
    syntax = "markdown",
    ext = ".md",
  },
}

vim.g.vimwiki_ext2syntax = {
  [".md"] = "markdown",
  [".markdown"] = "markdown",
  [".mdown"] = "markdown",
}
vim.g.vimwiki_markdown_link_ext = 1
vim.g.taskwiki_markup_syntax = "markdown"
vim.g.markdown_folding = 1
vim.g.vimwiki_key_mappings = {
  table_mappings = 0,
  links = 0,
}
