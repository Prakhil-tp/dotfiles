return {
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
  {

    "invim-telescope/telescope.nvim",
    url = "git@github.com:nvim-telescope/telescope.nvim.git",
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
        updatetime = 25,        -- Debounced time for highlighting nodes in the playground from source code
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

  -- git pacakges
  { "tpope/vim-fugitive" },
  { "lewis6991/gitsigns.nvim" },
  -- show colors
  { "norcalli/nvim-colorizer.lua" },
  { "lukas-reineke/indent-blankline.nvim" },
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
  {
    "vimwiki/vimwiki",
    event = "BufEnter *.md",
    cmd = { "VimwikiIndex", "VimwikiFollowLink", "VimwikiGoBackLink", "VimwikiVSplitLink" },
    keys = { "<leader>ww", "<leader>wt" },
  },
  { "airblade/vim-rooter" }, -- Changes Vim working directory to project root.

  -- UI
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
        separator_style = "slant",
      }
    }
  },
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
  {
    'numToStr/Comment.nvim',
    opts = {}
  }
}
