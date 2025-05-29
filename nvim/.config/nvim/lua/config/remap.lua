vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set({ 'n', 'v' }, 'y', '"+y') --  yank to clipboard

-- Buffer navigation
vim.api.nvim_set_keymap('n', '<TAB>', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-TAB>', ':bprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/', ':nohl<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'S', ':%s//g<left><left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ad', ':set autochdir<CR>', { noremap = true, silent = true })

-- Visual mode key mappings
-- Quick search and replace in visual mode with <C-r>
vim.api.nvim_set_keymap('v', '<C-r>', '"hy:%s/<C-r>h//gc<left><left><left>', { noremap = true, silent = true })

-- Check syntax highlighting by pressing F1
-- vim.api.nvim_set_keymap('n', '<silent> <F1>', ":echo 'hi<'.synIDattr(synID(line('.'), col('.'), 1), 'name')..'> trans<'..synIDattr(synID(line('.'), col('.'), 0), 'name')..'> lo<'..synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')..'><'<CR>", { noremap = true, silent = true })

vim.cmd('vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>"')




-- Navigate between splits
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true }) -- Move left
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true }) -- Move right
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true }) -- Move down
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true }) -- Move up


-- comment normal mode
vim.keymap.set('n', '<leader>ci', function()
  require('Comment.api').toggle.linewise.current()
end, { noremap = true, silent = true, desc = 'Toggle comment (current line)' })



-- comment visual mode
vim.keymap.set('x', '<leader>ci', function()
  local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'x', false)

  local api = require('Comment.api')
  local mode = vim.fn.visualmode()
  api.toggle.linewise(mode)
end, { noremap = true, silent = true, desc = 'Toggle comment (visual)' })


-- move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- search terms to stay middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "Q", "<nop>")

-- scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
