# dotfiles

[![top language](https://img.shields.io/github/languages/top/prakhil-tp/dotfiles)](https://github.com/prakhil-tp/dotfiles/search?l=vim%20script)
[![tag](https://img.shields.io/github/v/tag/prakhil-tp/dotfiles)](https://github.com/prakhil-tp/dotfiles/tags)
[![last commit](https://img.shields.io/github/last-commit/prakhil-tp/dotfiles)](https://github.com/Prakhil-tp/dotfiles/commits/master)

![dotfiles image](./dotfiles.png)

Configuration files  to customize Linux or unix-like systems. 

## Bootstrap (fresh Arch install)

The `bootstrap/install.sh` script recreates the full Arch Linux setup:

```sh
git clone https://github.com/Prakhil-tp/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap/install.sh --help
./bootstrap/install.sh --yes
```

It installs official repo packages from `bootstrap/packages.pacman`, AUR packages from `bootstrap/packages.aur`, copies `system/` into `/etc` and `/usr/local`, stows the home configuration, enables services, and installs optional runtimes.

Useful flags:

```text
--dry-run        print commands without running them
--skip-packages  skip official packages and the system upgrade
--skip-upgrade   skip only the full system upgrade
--skip-aur       skip AUR packages and yay bootstrap
--skip-system    skip /etc and /usr/local configuration
--skip-stow      skip stow-managed home configuration
--skip-services  skip enabling systemd services
--skip-apps      skip optional application builds
--skip-runtimes  skip asdf/npm runtimes
```

Before running, review `bootstrap/packages.*`, `bootstrap/services.*`, and `system/`. The installer does **not** copy hardware- or machine-specific data such as `/etc/fstab`, GRUB configuration, `mkinitcpio.conf`, SSH keys, browser profiles, wallpapers, or the hostname. Secrets belong in `~/.config/zsh/secrets.zsh`, seeded from `zsh/.config/zsh/secrets.zsh.example`.

## Configs

- [Alacritty](https://github.com/Prakhil-tp/dotfiles/tree/master/alacritty/.config/alacritty)
- [Alacritty (ThinkPad)](https://github.com/Prakhil-tp/dotfiles/tree/master/alacritty-thinkpad/.config/alacritty)
- [Anti-freeze](https://github.com/Prakhil-tp/dotfiles/tree/master/anti-freeze)
- [Applications](https://github.com/Prakhil-tp/dotfiles/tree/master/applications)
- [Atuin](https://github.com/Prakhil-tp/dotfiles/tree/master/atuin/.config/atuin)
- [Awesome WM](https://github.com/Prakhil-tp/dotfiles/tree/master/awesome/.config/awesome)
- [Bash](https://github.com/Prakhil-tp/dotfiles/tree/master/bash/)
- [Bat](https://github.com/Prakhil-tp/dotfiles/tree/master/bat/.config/bat/)
- [Conky](https://github.com/Prakhil-tp/dotfiles/tree/master/conky/.config/conky/)
- [Devilspie 2](https://github.com/Prakhil-tp/dotfiles/tree/master/devilspie2/.config/devilspie2/)
- [Dm-scripts](https://github.com/Prakhil-tp/dotfiles/tree/master/dm-scripts/scripts)
- [Doom Emacs](https://github.com/Prakhil-tp/dotfiles/tree/master/emacs/)
- [Dunst](https://github.com/Prakhil-tp/dotfiles/tree/master/dunst-notificaiton/.config/dunst/)
- [Env](https://github.com/Prakhil-tp/dotfiles/tree/master/env/)
- [Firefox](https://github.com/Prakhil-tp/dotfiles/tree/master/firefox/)
- [Fontconfig](https://github.com/Prakhil-tp/dotfiles/tree/master/fontconfig/.config/fontconfig)
- [Fzf](https://github.com/Prakhil-tp/dotfiles/tree/master/fzf/.local/share/fzf)
- [Git](https://github.com/Prakhil-tp/dotfiles/tree/master/git/.config/git)
- [Htop](https://github.com/Prakhil-tp/dotfiles/tree/master/htop/.config/htop)
- [Keyboard Interception](https://github.com/Prakhil-tp/dotfiles/tree/master/keyboard-interception/interception)
- [Kitty](https://github.com/Prakhil-tp/dotfiles/tree/master/kitty/.config/kitty)
- [Lightdm](https://github.com/Prakhil-tp/dotfiles/tree/master/lightdm/)
- [Lsd](https://github.com/Prakhil-tp/dotfiles/tree/master/lsd/.config/lsd)
- [Mpv](https://github.com/Prakhil-tp/dotfiles/tree/master/mpv/.config/mpv)
- [Mutt](https://github.com/Prakhil-tp/dotfiles/tree/master/mutt/.config/mutt/)
- [Neovim](https://github.com/Prakhil-tp/dotfiles/tree/master/nvim/.config/nvim/)
- [Newsboat](https://github.com/Prakhil-tp/dotfiles/tree/master/newsboat/.config/newsboat)
- [Npm](https://github.com/Prakhil-tp/dotfiles/tree/master/npm/.config/npm)
- [Nvm](https://github.com/Prakhil-tp/dotfiles/tree/master/nvm/)
- [Picom](https://github.com/Prakhil-tp/dotfiles/tree/master/picom/.config/picom)
- [Profile](https://github.com/Prakhil-tp/dotfiles/tree/master/profile/)
- [Qutebrowser](https://github.com/Prakhil-tp/dotfiles/tree/master/qutebrowser/.config/qutebrowser)
- [Remote-machine-zsh](https://github.com/Prakhil-tp/dotfiles/tree/master/remote-machine-zsh/)
- [Rofi](https://github.com/Prakhil-tp/dotfiles/tree/master/rofi/.config/rofi)
- [Systemd](https://github.com/Prakhil-tp/dotfiles/tree/master/systemd/.config/systemd)
- [Tabliss](https://github.com/Prakhil-tp/dotfiles/tree/master/tabliss-browser-extension/)
- [Tmux](https://github.com/Prakhil-tp/dotfiles/tree/master/tmux/)
- [Torrra](https://github.com/Prakhil-tp/dotfiles/tree/master/torrra/.config/torrra)
- [Ufetch](https://github.com/Prakhil-tp/dotfiles/tree/master/ufetch)
- [Vifm](https://github.com/Prakhil-tp/dotfiles/tree/master/vifm/.config/vifm/)
- [X11](https://github.com/Prakhil-tp/dotfiles/tree/master/X11/.config/X11)
- [Xmonad](https://github.com/Prakhil-tp/dotfiles/tree/master/xmonad/.xmonad)
- [Xterm](https://github.com/Prakhil-tp/dotfiles/tree/master/xterm/)
- [Zathura](https://github.com/Prakhil-tp/dotfiles/tree/master/zathura/.config/zathura)
- [Zsh](https://github.com/Prakhil-tp/dotfiles/tree/master/zsh/)

## How to use

### Full bootstrap

```sh
git clone https://github.com/Prakhil-tp/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap/install.sh --yes
```

### Manual stow

1. Clone the repository to your home directory.
2. Use `stow` to create symlinks for individual configs.

```sh
git clone https://github.com/Prakhil-tp/dotfiles.git
cd ./dotfiles
stow <directory-name>      # add a particular config, e.g. stow alacritty
```

Review `HANDOFF.md` for the current bootstrap status, known issues, and test instructions.

