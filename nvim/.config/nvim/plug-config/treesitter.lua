local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
  ensure_installed = {
    "python",
    "lua",
    "javascript",
    "typescript",
    "json",
    "html",
    "markdown",
    "css",
  },
	highlight = {
		enable = true,
		disable = { "" },
		additional_vim_regex_highlighting = true,
	},
	indent = { enable = true, disable = { "yaml" } },
	rainbow = { enable = true, extended_mode = true, max_file_lines = nil },
  playground = { enable = true }
})
