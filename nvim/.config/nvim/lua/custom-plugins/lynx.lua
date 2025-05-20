local M = {}

function M.fetch(url)
  if not url or url == "" then
    vim.api.nvim_err_writeln("Failed to run lynx")
    return
  end

  local handle = io.popen("lynx --source " .. vim.fn.shellescape(url))
  if not handle then
    vim.api.nvim_err_writeln("Failed to run lynx.")
    return
  end

  local result = handle:read("*a")
  handle:close()

  return result
end

function M.format_as_markdown(html)
  local tmp = os.tmpname()
  local f = io.open(tmp, "w")
  f:write(html)
  f:close()
  local formatted = io.popen("pandoc -f html -t markdown_strict " .. tmp):read("*a")
  os.remove(tmp)
  return formatted
end

function M.render(content)
  local lines = vim.split(content, "\n", { plain = true })
  -- Open a new scratch buffer
  vim.cmd("vnew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.bo.filetype = "markdown"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

function M.main(url)
  local raw_content = M.fetch(url)
  if not raw_content then
    return
  end
  local formatted_content = M.format_as_markdown(raw_content)
  M.render(formatted_content)
end

-- define command
vim.api.nvim_create_user_command("Web", function(opts)
  M.main(opts.args)
end, {
  nargs = 1,
  complete = "file"
})

return M
