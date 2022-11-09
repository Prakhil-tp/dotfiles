"" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Navigate with tmux
    Plug 'christoomey/vim-tmux-navigator'
    " Autocomplete
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Commenting codes
    Plug 'preservim/nerdcommenter'
    " Indent lines
    Plug 'Yggdroot/indentLine'
    " Auto closing tag
    Plug 'alvan/vim-closetag'
    " File manager
    Plug 'vifm/vifm.vim'
    "============================
    " Vim games
    "============================
    Plug 'ThePrimeagen/vim-be-good', {'do': './install.sh'}
    "============================
    " Syntax hightlight
    "============================
    "Plug 'othree/html5.vim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " Auto pairs for '(' '[' '{'
    Plug 'p00f/nvim-ts-rainbow' 
    Plug 'nvim-treesitter/playground'
    Plug 'plasticboy/vim-markdown'
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    "============================
    " Language support
    "============================
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    "============================
    " Git integration
    "============================
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'
    Plug 'junegunn/gv.vim'
    "============================
    " Search
    "============================
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'airblade/vim-rooter'
    "============================
    " Theme
    "============================
    "Plug 'morhetz/gruvbox'
    Plug 'dracula/vim', { 'as': 'dracula' }
    "============================
    " Statusbar and bufferline
    "============================
    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'
    Plug 'itchyny/vim-gitbranch'
    "============================
    " MarkDown
    "============================
    Plug 'godlygeek/tabular'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
    Plug 'junegunn/goyo.vim'
    "============================
    " Wiki
    "============================
    Plug 'vimwiki/vimwiki'
    Plug 'michal-h21/vimwiki-sync'
    "============================
    " HTML 
    "============================
    Plug 'turbio/bracey.vim' " Live server
    Plug 'mattn/emmet-vim'
    "============================
    " Debugger
    "============================
    Plug 'puremourning/vimspector'

    call plug#end()

