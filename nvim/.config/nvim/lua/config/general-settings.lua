-- Custom highlighting for TypeScript
--
-- vim.api.nvim_set_hl(0, "@typescriptBlock", { fg = "#5E81AC", bold = true })   -- example color for blocks
-- vim.api.nvim_set_hl(0, "@typescriptProp", { fg = "#D08770", italic = true })  -- example color for props


-- Enable syntax highlighting
vim.cmd('syntax enable')

-- Enable filetype detection, plugins, and indenting
vim.cmd('filetype on')
vim.cmd('filetype plugin indent on')

-- Set various options
vim.opt.hidden = true          -- Required to keep multiple buffers open
vim.opt.wrap = false           -- Display long lines as just one line
vim.opt.encoding = 'utf-8'     -- The encoding displayed
vim.opt.pumheight = 10         -- Makes popup menu smaller
vim.opt.fileencoding = 'utf-8' -- The encoding written to file
vim.opt.ruler = true           -- Show the cursor position all the time
vim.opt.cmdheight = 2          -- More space for displaying messages
vim.opt.iskeyword:append('-')  -- Treat dash separated words as a word text object
vim.opt.mouse = 'a'            -- Enable mouse
vim.opt.splitbelow = true      -- Horizontal splits will automatically be below
vim.opt.splitright = true      -- Vertical splits will automatically be to the right
vim.opt.termguicolors = true   -- Support 256 colors
vim.opt.conceallevel = 0       -- So that I can see `` in markdown files
vim.opt.tabstop = 2            -- Insert 2 spaces for a tab
vim.opt.shiftwidth = 2         -- Change the number of space characters inserted for indentation
vim.opt.smarttab = true        -- Makes tabbing smarter
vim.opt.expandtab = true       -- Converts tabs to spaces
vim.opt.smartindent = true     -- Makes indenting smart
vim.opt.autoindent = true      -- Good auto indent
vim.opt.laststatus = 3         -- Always display the status line
vim.opt.number = true          -- Line numbers
vim.opt.relativenumber = true  -- Relative line numbers
-- vim.opt.cursorline = true             -- Enable highlighting of the current line
-- vim.opt.background = 'dark'           -- Tell Neovim what the background color looks like
vim.opt.showtabline = 2                     -- Always show tabs
vim.opt.showmode = false                    -- We don't need to see things like -- INSERT -- anymore
vim.opt.backup = false                      -- Disable backup files
vim.opt.writebackup = false                 -- Disable write backup files
vim.opt.updatetime = 300                    -- Faster completion
vim.opt.timeoutlen = 500                    -- Timeout length for key mappings
vim.opt.formatoptions:remove('c', 'r', 'o') -- Stop newline continuation of comments
vim.opt.clipboard:append('unnamedplus')     -- Copy paste between Neovim and everything else
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50

-- Disable compatibility mode
vim.opt.compatible = false


-- fix indenting in visual block mode
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })


vim.cmd('command! BufOnly silent! execute "%bd|e#|bd#"')

-- Disable syntax highlighting for CSV files
vim.cmd('autocmd! bufreadpost *.csv set syntax=off')
