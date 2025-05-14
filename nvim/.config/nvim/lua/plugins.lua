return {
  -- theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "auto", -- latte, frappe, macchiato, mocha
      background = {    -- :h background
        light = "latte",
        dark = "mocha",
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        notify = true,
        mini = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,

  },
  -- file navigation
  {

    "invim-telescope/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim.git",
    tag = "0.1.8",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "typescript", "javascript", "json", "bash", "html", "css" },
      auto_install = true,
      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        },
      }

    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end
  },
  { 'nvim-treesitter/playground' },
  -- file manager
  {
    "nvim-tree/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return require "config.plugin-configs.nvim-tree"
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },

  -- git pacakges
  { "tpope/vim-fugitive" },
  { "lewis6991/gitsigns.nvim" },
  -- wiki
  {
    "vimwiki/vimwiki",
    event = "BufEnter *.md",
    cmd = { "VimwikiIndex", "VimwikiFollowLink", "VimwikiGoBackLink", "VimwikiVSplitLink" },
    keys = { "<leader>ww", "<leader>wt" },
  },
  { "git@github.com:michal-h21/vimwiki-sync.git" },
  { "airblade/vim-rooter" }, -- Changes Vim working directory to project root.
  -- top bufferline
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers", -- or "tabs"
        diagnostics = "nvim_lsp",
        show_close_icon = false,
        show_buffer_close_icons = true,
        separator_style = "thick",
      }
    }
  },
  -- bottom statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "filetype" }, -- no encoding here
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  -- Language server
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    config = true,
    opts = {
      automatic_enable = false,
      ensure_installed = { "ts_ls", "lua_ls" }
    },
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },

      -- snippets
      { "L3MON4D3/LuaSnip" },
    },
  },
  -- comment
  {
    'numToStr/Comment.nvim',
    opts = {}
  },
  -- smooth scrolling
  {
    "karb94/neoscroll.nvim",
    opts = {
      mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        '<C-u>', '<C-d>',
        '<C-b>', '<C-f>',
        '<C-y>', '<C-e>',
        'zt', 'zz', 'zb',
      },
      hide_cursor = true,          -- Hide cursor while scrolling
      stop_eof = true,             -- Stop at <EOF> when scrolling downwards
      respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      duration_multiplier = 1.0,   -- Global duration multiplier
      easing = 'linear',           -- Default easing function
      pre_hook = nil,              -- Function to run before the scrolling animation starts
      post_hook = nil,             -- Function to run after the scrolling animation ends
      performance_mode = false,    -- Disable "Performance Mode" on all buffers.
      ignored_events = {           -- Events ignored while scrolling
        'WinScrolled', 'CursorMoved'
      },
    },
  },
  -- show colors for the hash #fff
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  -- indent lines
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  { "ThePrimeagen/vim-be-good" }

}
