local builtin = require('telescope.builtin')

local find_files_all = function()
  builtin.find_files({
    hidden = true,
    file_ignore_patterns = { "node_modules/", ".git/", "dist/", "build/" }
  })
end

vim.keymap.set('n', '<C-p>', find_files_all, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>r', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
