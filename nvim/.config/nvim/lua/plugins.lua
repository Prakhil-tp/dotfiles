return {
  -- theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "auto", -- latte, frappe, macchiato, mocha
      transparent_background = true,
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
        bufferline = true,
      },
      custom_highlights = function(colors)
        return {
          StatusLine = { bg = colors.base },   -- opaque background color from the palette
          StatusLineNC = { bg = colors.base }, -- inactive statusline too
        }
      end

    },
    config = function(_, opts)
      vim.opt.termguicolors = true
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
        mode = "buffers",
        diagnostics = "nvim_lsp",
        show_close_icon = false,
        show_buffer_close_icons = true,
        separator_style = "thin",
      },
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
  { "williamboman/mason.nvim",     config = true },
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
  -- snippets
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },

  -- formatter
  {
    "nvimtools/none-ls.nvim",
    config = function()
      require("config.plugin-configs.none-ls")
    end
  },

  -- comment
  {
    'numToStr/Comment.nvim',
    opts = {}
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
  { "ThePrimeagen/vim-be-good" },
  {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" },
        mark_branch = false,
        tabline = false,
        tabline_prefix = "   ",
        tabline_suffix = "   ",
      })
    end
  }

}
