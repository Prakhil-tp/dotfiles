#!/usr/bin/env bash
set -Eeuo pipefail

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/Prakhil-tp/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

DRY_RUN=0
ASSUME_YES=0
SKIP_PACKAGES=0
SKIP_UPGRADE=0
SKIP_AUR=0
SKIP_SYSTEM=0
SKIP_STOW=0
SKIP_SERVICES=0
SKIP_APPS=0
SKIP_RUNTIMES=0

log() { printf '\033[1;34m[*]\033[0m %s\n' "$*"; }
ok() { printf '\033[1;32m[+]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
Usage: bootstrap/install.sh [options]

Recreate this Arch Linux setup from the dotfiles repository.

Options:
  -y, --yes            Do not ask for confirmation
      --dry-run        Show commands without running them
      --skip-packages  Skip official repo packages (also skips the system upgrade)
      --skip-upgrade   Skip the full system upgrade, still install packages
      --skip-aur       Skip AUR packages and yay bootstrap
      --skip-system    Skip /etc and /usr/local configuration
      --skip-stow      Skip stow-managed home configuration
      --skip-services  Skip enabling systemd services
      --skip-apps      Skip building optional applications
      --skip-runtimes  Skip asdf language runtimes and npm dependencies
  -h, --help           Show this help

Environment:
  DOTFILES_REPO_URL    Git URL to clone (default: upstream repo)
  DOTFILES_DIR         Clone destination (default: ~/dotfiles)
EOF
}

while (($#)); do
  case "$1" in
    -y | --yes) ASSUME_YES=1 ;;
    --dry-run) DRY_RUN=1 ;;
    --skip-packages) SKIP_PACKAGES=1 ;;
    --skip-upgrade) SKIP_UPGRADE=1 ;;
    --skip-aur) SKIP_AUR=1 ;;
    --skip-system) SKIP_SYSTEM=1 ;;
    --skip-stow) SKIP_STOW=1 ;;
    --skip-services) SKIP_SERVICES=1 ;;
    --skip-apps) SKIP_APPS=1 ;;
    --skip-runtimes) SKIP_RUNTIMES=1 ;;
    -h | --help)
      usage
      exit 0
      ;;
    *) die "Unknown option: $1" ;;
  esac
  shift
done

run() {
  if ((DRY_RUN)); then
    printf '  >>'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

run_sudo() {
  if ((DRY_RUN)); then
    printf '  >> sudo'
    printf ' %q' "$@"
    printf '\n'
  else
    sudo "$@"
  fi
}

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

if [[ -f "$SCRIPT_DIR/../bootstrap/install.sh" && -d "$SCRIPT_DIR/../.git" ]]; then
  REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
else
  REPO_ROOT=""
fi

if [[ -z "$REPO_ROOT" ]]; then
  if ! command -v git >/dev/null 2>&1; then
    command -v pacman >/dev/null 2>&1 || die "git is required to clone the dotfiles"
    sudo pacman -Sy --needed --noconfirm git
  fi
  log "Cloning dotfiles into $DOTFILES_DIR"
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    run git -C "$DOTFILES_DIR" pull --ff-only || warn "Could not update $DOTFILES_DIR"
  else
    run git clone "$REPO_URL" "$DOTFILES_DIR"
  fi
  exec bash "$DOTFILES_DIR/bootstrap/install.sh" "$@"
fi

((EUID == 0)) && die "Run this as your normal user, not root. The script uses sudo."
command -v pacman >/dev/null 2>&1 || die "This script targets Arch Linux (pacman not found)."

if ((DRY_RUN == 0)); then
  sudo -v || die "sudo access is required"
fi

if ((ASSUME_YES == 0 && DRY_RUN == 0)); then
  printf 'This will install packages and modify system configuration. Continue? [y/N] '
  if ! read -r reply; then
    die "No input available; re-run with --yes"
  fi
  [[ "$reply" =~ ^[Yy]$ ]] || exit 0
fi

if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  [[ "${ID:-}" == "arch" ]] || warn "Detected ${ID:-unknown}; continuing anyway."
fi

if ((SKIP_PACKAGES == 0)); then
  if ((SKIP_UPGRADE == 0)); then
    log "Updating package databases and upgrading the system"
    run_sudo pacman -Syu --needed --noconfirm
  else
    log "Skipping full system upgrade (--skip-upgrade)"
  fi
  log "Installing bootstrap tools"
  run_sudo pacman -S --needed --noconfirm git base-devel sudo stow curl
else
  log "Skipping official repo packages (--skip-packages)"
  for tool in git stow curl; do
    command -v "$tool" >/dev/null 2>&1 || die "$tool is required; run without --skip-packages first"
  done
fi

if ((SKIP_AUR == 0)) && ! grep -q '^\[multilib\]' /etc/pacman.conf; then
  log "Enabling the multilib repository"
  run_sudo sed -i '/^#\[multilib\]$/,/^#Include = \/etc\/pacman.d\/mirrorlist$/ s/^#//' /etc/pacman.conf
  run_sudo pacman -Sy --noconfirm
fi

mapfile -t PACMAN_PKGS < <(grep -vE '^[[:space:]]*(#|$)' "$REPO_ROOT/bootstrap/packages.pacman")
mapfile -t AUR_PKGS < <(grep -vE '^[[:space:]]*(#|$)' "$REPO_ROOT/bootstrap/packages.aur")

install_official_packages() {
  local pkg
  local available=()
  log "Checking official repo packages (${#PACMAN_PKGS[@]})"
  for pkg in "${PACMAN_PKGS[@]}"; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
      available+=("$pkg")
    else
      warn "Not available in enabled repos, skipping: $pkg"
    fi
  done
  ((${#available[@]})) || return 0
  log "Installing official packages (${#available[@]})"
  if ! run_sudo pacman -S --needed --noconfirm "${available[@]}"; then
    warn "Batch install failed; retrying packages one by one"
    for pkg in "${available[@]}"; do
      run_sudo pacman -S --needed --noconfirm "$pkg" || warn "Failed: $pkg"
    done
  fi
}

install_aur_packages() {
  local pkg
  local tmp
  if ! command -v yay >/dev/null 2>&1; then
    log "Bootstrapping yay"
    tmp="$(mktemp -d)"
    if run git clone https://aur.archlinux.org/yay.git "$tmp/yay"; then
      if ((DRY_RUN)); then
        printf '  >> (cd %q && makepkg -si --noconfirm)\n' "$tmp/yay"
      else
        if ! (cd "$tmp/yay" && makepkg -si --noconfirm); then
          warn "yay build failed; skipping AUR packages"
          rm -rf "$tmp"
          return 0
        fi
      fi
    else
      warn "Could not clone yay; skipping AUR packages"
      rm -rf "$tmp"
      return 0
    fi
    rm -rf "$tmp"
  fi

  log "Installing AUR packages (${#AUR_PKGS[@]})"
  for pkg in "${AUR_PKGS[@]}"; do
    [[ "$pkg" == "yay" ]] && continue
    if pacman -Qq "$pkg" >/dev/null 2>&1; then
      continue
    fi
    run yay -S --needed --noconfirm --answerclean None --answerdiff None --answeredit None "$pkg" ||
      warn "AUR package failed: $pkg"
  done
}

install_system_config() {
  local src rel mode target

  log "Installing /etc and /usr/local configuration"
  while IFS= read -r -d '' src; do
    rel="${src#"$REPO_ROOT/system/"}"
    target="/$rel"
    mode="$(stat -c '%a' "$src")"
    run_sudo install -Dm"$mode" "$src" "$target"
  done < <(find "$REPO_ROOT/system" -type f -print0)

  for src in "$REPO_ROOT"/lightdm/*.conf; do
    [[ -e "$src" ]] || continue
    run_sudo install -Dm644 "$src" "/etc/lightdm/$(basename "$src")"
  done

  if [[ -d "$REPO_ROOT/keyboard-interception/interception" ]]; then
    run_sudo mkdir -p /etc/interception
    if ((DRY_RUN)); then
      printf '  >> sudo cp -a %q/. /etc/interception/\n' "$REPO_ROOT/keyboard-interception/interception"
    else
      sudo cp -a "$REPO_ROOT/keyboard-interception/interception/." /etc/interception/
    fi
  fi

  if [[ -f "$REPO_ROOT/anti-freeze/install.sh" ]]; then
    if ((DRY_RUN)); then
      run_sudo bash "$REPO_ROOT/anti-freeze/install.sh" --dry-run
    else
      run_sudo bash "$REPO_ROOT/anti-freeze/install.sh" || warn "anti-freeze install failed"
    fi
  fi

  if [[ -f "$REPO_ROOT/local-bin/.local/bin/battery-ac-notify" ]]; then
    run_sudo install -Dm755 "$REPO_ROOT/local-bin/.local/bin/battery-ac-notify" /usr/local/bin/battery-ac-notify
  fi

  if command -v unbound-control-setup >/dev/null 2>&1 && [[ ! -f /etc/unbound/unbound_server.key ]]; then
    run_sudo unbound-control-setup || warn "unbound-control-setup failed"
  fi
  if command -v unbound-anchor >/dev/null 2>&1; then
    run_sudo unbound-anchor -a /etc/unbound/trusted-key.key || warn "unbound-anchor failed (offline?)"
  fi
  if [[ ! -f /etc/unbound/resolvconf.conf ]]; then
    run_sudo install -Dm644 /dev/null /etc/unbound/resolvconf.conf
  fi

  if [[ -f /etc/locale.gen ]] && grep -q '^#en_US.UTF-8 UTF-8' /etc/locale.gen; then
    run_sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
  fi
  run_sudo locale-gen || warn "locale-gen failed"

  run_sudo sysctl --system || warn "sysctl --system failed"
  run_sudo udevadm control --reload-rules || warn "Could not reload udev rules"
  run_sudo udevadm trigger || warn "Could not trigger udev"

  run_sudo groupadd -f docker || warn "Could not create docker group"
  run_sudo groupadd -f media || warn "Could not create media group"
  run_sudo usermod -aG docker,media "$USER" || warn "Could not add $USER to docker/media groups"
  for svc_user in jellyfin prowlarr radarr sonarr transmission; do
    if id "$svc_user" >/dev/null 2>&1; then
      run_sudo usermod -aG media "$svc_user" || warn "Could not add $svc_user to media"
    fi
  done
}

STOW_PACKAGES=(
  alacritty
  asdf
  atuin
  awesome
  bash
  bat
  cava
  conky
  devilspie2
  dmenu
  dm-scripts
  dunst-notificaiton
  emacs
  env
  fish
  fontconfig
  fzf
  git
  htop
  kitty
  local-bin
  lsd
  mpv
  mutt
  newsboat
  npm
  nvim
  opencode
  picom
  profile
  qutebrowser
  rofi
  systemd
  tmux
  torrra
  ufetch
  vifm
  X11
  xdg
  xmonad
  xterm
  yt-x
  zathura
  zsh
)

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

backup_target() {
  local target="$1"
  local rel="${target#"$HOME"/}"
  local dest="$BACKUP_DIR/$rel"
  run mkdir -p "$(dirname "$dest")"
  run mv "$target" "$dest"
  warn "Backed up $target -> $dest"
}

prepare_stow() {
  local pkg="$1"
  local pkgdir="$REPO_ROOT/$pkg"
  local src rel target real parent

  while IFS= read -r -d '' src; do
    rel="${src#"$pkgdir"/}"
    target="$HOME/$rel"
    real="$(realpath -m "$target")"
    [[ "$real" == "$REPO_ROOT"/* ]] && continue

    parent="$(dirname "$target")"
    while [[ "$parent" != "$HOME" && "$parent" != "/" ]]; do
      if [[ -e "$parent" && ! -d "$parent" ]]; then
        real="$(realpath -m "$parent")"
        [[ "$real" == "$REPO_ROOT"/* ]] || backup_target "$parent"
        break
      fi
      parent="$(dirname "$parent")"
    done

    if [[ -e "$target" || -L "$target" ]]; then
      real="$(realpath -m "$target")"
      [[ "$real" == "$REPO_ROOT"/* ]] || backup_target "$target"
    fi
  done < <(find "$pkgdir" \( -type f -o -type l \) ! -name 'secrets.zsh' -print0)
}

# torrra's config holds indexer API keys, so it is rendered from pass
# (api/jackett, api/prowlarr) instead of being tracked in the repo.
render_torrra_config() {
  local example="$REPO_ROOT/torrra/.config/torrra/config.toml.example"
  local target="$HOME/.config/torrra/config.toml"
  local jackett prowlarr

  [[ -e "$target" && ! -L "$target" ]] && return 0
  if ((DRY_RUN)); then
    printf '  >> render %q from pass -> %q\n' "$example" "$target"
    return 0
  fi

  if ! command -v pass >/dev/null 2>&1 ||
    ! jackett="$(pass show api/jackett 2>/dev/null | head -n1)" ||
    ! prowlarr="$(pass show api/prowlarr 2>/dev/null | head -n1)"; then
    warn "pass entries api/jackett and api/prowlarr unavailable; torrra config left unrendered"
    return 0
  fi

  [[ -L "$target" ]] && rm "$target"
  mkdir -p "$(dirname "$target")"
  (
    umask 077
    sed -e "s|@JACKETT_API_KEY@|$jackett|" -e "s|@PROWLARR_API_KEY@|$prowlarr|" "$example" >"$target"
  )
  ok "Rendered $target from pass"
}

stow_home_config() {
  local pkg
  log "Stowing home configuration"
  for pkg in "${STOW_PACKAGES[@]}"; do
    [[ -d "$REPO_ROOT/$pkg" ]] || {
      warn "Missing stow package: $pkg"
      continue
    }
    prepare_stow "$pkg"
    run stow --no-folding --ignore='secrets\.zsh' -d "$REPO_ROOT" -t "$HOME" "$pkg" || warn "stow failed for $pkg"
  done

  run mkdir -p \
    "$HOME/.cache" "$HOME/.local/state" "$HOME/.local/share" \
    "$HOME/code/projects" "$HOME/code/playground" "$HOME/documents/notes" \
    "$HOME/downloads" "$HOME/videos" "$HOME/desktop" "$HOME/templates" \
    "$HOME/public" "$HOME/music" "$HOME/pictures/wallpapers" "$HOME/projects"

  run ln -sfn .config/X11/xprofile "$HOME/.xprofile"
  run ln -sfn .config/X11/Xresources "$HOME/.Xresources"
  run ln -sfn .config/dmrc "$HOME/.dmrc"
  run ln -sfn .config/asdf/tool-versions "$HOME/.tool-versions"

  if [[ ! -f "$HOME/.config/zsh/secrets.zsh" ]]; then
    run install -Dm600 "$REPO_ROOT/zsh/.config/zsh/secrets.zsh.example" "$HOME/.config/zsh/secrets.zsh"
  fi

  render_torrra_config

  if [[ ! -e "$HOME/pictures/wallpapers/default.png" ]]; then
    run cp "$REPO_ROOT/awesome/.config/awesome/themes/default/background.png" "$HOME/pictures/wallpapers/default.png"
  fi

  if command -v bat >/dev/null 2>&1; then
    run bat cache --build || warn "bat cache build failed"
  fi
}

enable_services() {
  local svc

  log "Enabling system services"
  while IFS= read -r svc; do
    [[ -z "$svc" || "$svc" == \#* ]] && continue
    if ! systemctl cat "$svc" >/dev/null 2>&1; then
      warn "Missing system unit, skipping: $svc"
      continue
    fi
    run_sudo systemctl enable "$svc" || warn "Could not enable $svc"
  done <"$REPO_ROOT/bootstrap/services.system"
  run_sudo systemctl daemon-reload || warn "systemctl daemon-reload failed"

  export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
  run_sudo loginctl enable-linger "$USER" || warn "Could not enable linger for $USER"

  log "Enabling user services and timers"
  while IFS= read -r svc; do
    [[ -z "$svc" || "$svc" == \#* ]] && continue
    if ! systemctl --user cat "$svc" >/dev/null 2>&1; then
      warn "Missing user unit, skipping: $svc"
      continue
    fi
    run systemctl --user enable "$svc" || warn "Could not enable user unit $svc"
  done <"$REPO_ROOT/bootstrap/services.user"
  run systemctl --user daemon-reload || warn "user systemctl daemon-reload failed"
}

install_apps() {
  local tmp

  if [[ -f "$REPO_ROOT/applications/dmenu-patched-5.2.tar.gz" ]]; then
    log "Building patched dmenu"
    tmp="$(mktemp -d)"
    run tar -xzf "$REPO_ROOT/applications/dmenu-patched-5.2.tar.gz" -C "$tmp"
    if [[ -d "$tmp/dmenu-5.2" ]]; then
      run make -C "$tmp/dmenu-5.2" clean
      run make -C "$tmp/dmenu-5.2"
      run_sudo make -C "$tmp/dmenu-5.2" install
    else
      ((DRY_RUN)) || warn "dmenu archive did not contain dmenu-5.2"
    fi
    rm -rf "$tmp"
  fi

  if [[ -f "$REPO_ROOT/applications/paleofetch" ]]; then
    run install -Dm755 "$REPO_ROOT/applications/paleofetch" "$HOME/.local/bin/paleofetch"
  fi

  if [[ -f "$REPO_ROOT/system/usr/local/bin/unimatrix" ]]; then
    run_sudo install -Dm755 "$REPO_ROOT/system/usr/local/bin/unimatrix" /usr/local/bin/unimatrix
  fi

  if ! command -v dual-function-keys >/dev/null 2>&1; then
    log "Building dual-function-keys"
    tmp="$(mktemp -d)"
    if run git clone --depth 1 https://gitlab.com/interception/linux/plugins/dual-function-keys.git "$tmp/dual-function-keys"; then
      run make -C "$tmp/dual-function-keys" || warn "dual-function-keys build failed"
      run_sudo make -C "$tmp/dual-function-keys" install || warn "dual-function-keys install failed"
    else
      warn "Could not clone dual-function-keys"
    fi
    rm -rf "$tmp"
  fi
}

install_runtimes() {
  if ! command -v asdf >/dev/null 2>&1; then
    warn "asdf not found; skipping language runtimes"
    return 0
  fi

  if [[ ! -d "$HOME/.local/share/asdf-lib/.git" ]]; then
    run git clone https://github.com/asdf-vm/asdf.git "$HOME/.local/share/asdf-lib" --branch v0.18.0 ||
      warn "Could not clone asdf"
  fi

  export ASDF_DIR="$HOME/.local/share/asdf-lib"
  export ASDF_DATA_DIR="$HOME/.local/share/asdf"
  export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="$HOME/.config/asdf/tool-versions"

  if [[ -f "$HOME/.config/asdf/tool-versions" ]]; then
    run asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || warn "Could not add nodejs plugin"
    run asdf install || warn "asdf install failed"
  fi

  if [[ -f "$HOME/.config/opencode/package.json" ]] && command -v npm >/dev/null 2>&1; then
    if ((DRY_RUN)); then
      printf '  >> (cd %q && npm install --no-package-lock)\n' "$HOME/.config/opencode"
    else
      (cd "$HOME/.config/opencode" && npm install --no-package-lock) || warn "npm install failed in opencode config"
    fi
  fi
}

((SKIP_PACKAGES)) || install_official_packages
((SKIP_AUR)) || install_aur_packages
((SKIP_SYSTEM)) || install_system_config
((SKIP_STOW)) || stow_home_config
((SKIP_APPS)) || install_apps
((SKIP_SERVICES)) || enable_services
((SKIP_RUNTIMES)) || install_runtimes

ok "Bootstrap complete."
warn "Log out and back in (or reboot) so group changes and services take effect."
warn "Review ~/.config/zsh/secrets.zsh and install any missing language runtimes or models."
