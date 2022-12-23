# ZSH

## Installation

#### 1. Import alacritty terminfo
```sh
  tic -x ~/dotfiles/remote-machine-zsh/alacritty.terminfo
```
#### 2. Install zsh and make it default
```sh
  pacman -S zsh
  sudo chsh -s /usr/bin/zsh
```
#### 3. Install necessary plugins
  Before the installation, you need to make sure there're necessary linux utility tools are present in your system.
  ```sh
    pacman -S curl wget git
  ```
  Add zsh-autosuggestions
  ```sh
    pacman -S zsh-autosuggestions
  ```
  Add zsh-syntax-highlighting
  ```sh
    pacman -S zsh-syntax-highlighting
  ```
