# dotfiles

[![top language](https://img.shields.io/github/languages/top/prakhil-tp/dotfiles)](https://github.com/prakhil-tp/dotfiles/search?l=vim%20script)
[![tag](https://img.shields.io/github/v/tag/prakhil-tp/dotfiles)](https://github.com/prakhil-tp/dotfiles/tags)
[![last commit](https://img.shields.io/github/last-commit/prakhil-tp/dotfiles)](https://github.com/Prakhil-tp/dotfiles/commits/master)

Configuration files that are used to personalize your Linux or unix-like systems. 

## Configs

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
- [Ufetch](https://github.com/Prakhil-tp/dotfiles/tree/master/ufetch)

## How to use

1. Clone the repository to home directory
2. Let the `stow` to do the job. (stow will create corresponding config symlinks in appropriate directories.)

``` sh
git clone https://github.com/Prakhil-tp/dotfiles.git
cd ./dotfiles
stow */         # stow <directory-name>  - for adding a purticular config
```

## setup zsh
#### 1. Import alacritty terminfo
```sh
  tic -x ~/dotfiles/remote-machine-zsh/alacritty.terminfo
```
#### 2. Install zsh and make it default
```sh
  sudo apt install zsh
  sudo chsh -s /usr/bin/zsh
```
#### 3. Install oh-my-zsh and its plugins
  Before the installation, you need to make sure there're necessary linux utility tools are present in your system.
  ```sh
    sudo apt install curl wget git
  ```
  Install oh-my-zsh via wget
  ```sh
  $ sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  ```
  Add powerlevel9k theme
  ```sh
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
  ```
  Add zsh-autosuggestions
  ```sh
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  ```
  Load the `.zshrc` file again using the following command
  ```sh
    source ~/.zshrc
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
``` sh
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
```
## setup doom emacs
1. install emacs
2. clone doom repository to `.emacs.d` directory

``` sh
sudo dnf install emacs #fedora

git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom sync
```
