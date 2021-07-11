# dotfiles

[![top language](https://img.shields.io/github/languages/top/prakhil-tp/dotfiles)](https://github.com/prakhil-tp/dotfiles/search?l=vim%20script)
[![tag](https://img.shields.io/github/v/tag/prakhil-tp/dotfiles)](https://github.com/prakhil-tp/dotfiles/tags)
[![last commit](https://img.shields.io/github/last-commit/prakhil-tp/dotfiles)](https://github.com/Prakhil-tp/dotfiles/commits/master)

Configuration files that are used to personalize your Linux or unix-like systems. 

## Popular configs of mine

- [Alacritty](https://github.com/Prakhil-tp/dotfiles/tree/master/Alacritty/.config/)
- [Bash](https://github.com/Prakhil-tp/dotfiles/tree/master/bash/)
- [Zsh](https://github.com/Prakhil-tp/dotfiles/tree/master/zsh/)
- [Bat](https://github.com/Prakhil-tp/dotfiles/tree/master/bat/.config/bat/)
- [Devilspie 2](https://github.com/Prakhil-tp/dotfiles/tree/master/devilspie2/.config/devilspie2/)
- [Doom Emacs](https://github.com/Prakhil-tp/dotfiles/tree/master/emacs/)
- [Fzf](https://github.com/Prakhil-tp/dotfiles/tree/master/fzf/)
- [Neovim](https://github.com/Prakhil-tp/dotfiles/tree/master/nvim/.config/nvim/)
- [Tmux](https://github.com/Prakhil-tp/dotfiles/tree/master/tmux/)
- [Vifm](https://github.com/Prakhil-tp/dotfiles/tree/master/vifm/.config/vifm/)

## How to use

1. Clone the repository to home directory
2. Let the `stow` to do the job. (stow will create corresponding config symlinks in appropriate directories.)

``` sh
git clone https://github.com/Prakhil-tp/dotfiles.git
cd ./dotfiles
stow */
```

## setup nvim

1. open `vim ~/.config/nvim/vim-plug/plugins.vim`
2. run the vim commands one after another.

``` vim-snippet
:PlugInstall
:CocInstall coc-prettier coc-snippets
```

## setup fzf 

1. clone and install `fzf`
2. stow .fzf.bash / .fzf.zsh files
{{{
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
}}}
