# ZSH

## Installation

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
  Add zsh-syntax-highlighting
  ```sh
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
  ```
