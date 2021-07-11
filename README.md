# dotfiles

[![top language](https://img.shields.io/github/languages/top/prakhil-tp/dotfiles)](https://github.com/prakhil-tp/dotfiles/search?l=vim%20script)
[![tag](https://img.shields.io/github/v/tag/prakhil-tp/dotfiles)](https://github.com/prakhil-tp/dotfiles/tags)
[![last commit](https://img.shields.io/github/last-commit/prakhil-tp/dotfiles)](https://github.com/Prakhil-tp/dotfiles/commits/master)

Configuration files that are used to personalize your Linux or unix-like systems. 

## Popular configs of mine

- [[https://github.com/Prakhil-tp/dotfiles/tree/master/Alacritty/.config/][Alacritty]]
- [[https://github.com/Prakhil-tp/dotfiles/tree/master/bash/][Bash]]
- [[https://github.com/Prakhil-tp/dotfiles/tree/master/zsh/][Zsh]]
- [[https://github.com/Prakhil-tp/dotfiles/tree/master/bat/.config/bat/][Bat]]
- [[https://github.com/Prakhil-tp/dotfiles/tree/master/devilspie2/.config/devilspie2/][Devilspie 2]]
- [[https://github.com/Prakhil-tp/dotfiles/tree/master/emacs/][Doom Emacs]]
- [[https://github.com/Prakhil-tp/dotfiles/tree/master/fzf/][Fzf]]
- [[https://github.com/Prakhil-tp/dotfiles/tree/master/nvim/.config/nvim/][Neovim]]
- [[https://github.com/Prakhil-tp/dotfiles/tree/master/tmux/][Tmux]]
- [[https://github.com/Prakhil-tp/dotfiles/tree/master/vifm/.config/vifm/][Vifm]]

## How to use

1. Clone the repository to home directory
2. Let the `stow` to do the job. (stow will create corresponding config symlinks in appropriate directories.)

``` sh
git clone https://github.com/Prakhil-tp/dotfiles.git
cd ./dotfiles
stow */
```

## configure nvim

1. open `vim ~/.config/nvim/vim-plug/plugins.vim`
2. run the vim commands one after another.

``` vim-snippet
:PlugInstall
:CocInstall coc-prettier coc-snippets
```

## configure fzf 

1. clone and install `fzf`
2. stow .fzf.bash / .fzf.zsh files
{{{
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
}}}
