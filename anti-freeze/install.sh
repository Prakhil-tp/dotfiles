#!/bin/bash
set -euo pipefail

# anti-freeze install script
# Run with: bash install.sh
# Optionally: bash install.sh --dry-run  (preview only)

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

info()  { echo -e "\\033[1;34m[*]\\033[0m $*"; }
ok()    { echo -e "\\033[1;32m[+]\\033[0m $*"; }
warn()  { echo -e "\\033[1;33m[!]\\033[0m $*"; }
run()   {
  if $DRY_RUN; then echo -e "\\033[2m  >> $*\\033[0m"
  else "$@"; fi
}

if [[ $DRY_RUN == false && $EUID -ne 0 ]]; then
  sudo bash "$0" "$@"
  exit $?
fi

# ---- Distro detection ----
if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  DISTRO="$ID"
elif command -v lsb_release &>/dev/null; then
  DISTRO="$(lsb_release -is | tr '[:upper:]' '[:lower:]')"
else
  DISTRO="unknown"
fi

info "Detected distro: $DISTRO"

case "$DISTRO" in
  arch|manjaro|endeavouros|arcolinux)
    PKG_MANAGER="pacman -S --noconfirm"
    EARLYOOM_PKG="earlyoom"
    # zram handled by our service + zramctl (in util-linux, always present)
    STRESS_PKG="stress-ng"
    ZRAM_SERVICE_DIR="/etc/systemd/system"
    ;;
  debian|ubuntu|pop|linuxmint|elementary|zorin)
    PKG_MANAGER="apt-get install -y"
    EARLYOOM_PKG="earlyoom"
    # zram-tools provides zramswap service; we override with our own
    STRESS_PKG="stress-ng"
    ZRAM_SERVICE_DIR="/etc/systemd/system"
    ;;
  fedora|rhel|centos)
    PKG_MANAGER="dnf install -y"
    EARLYOOM_PKG="earlyoom"
    STRESS_PKG="stress-ng"
    ZRAM_SERVICE_DIR="/etc/systemd/system"
    ;;
  opensuse*|suse)
    PKG_MANAGER="zypper install -y"
    EARLYOOM_PKG="earlyoom"
    STRESS_PKG="stress-ng"
    ZRAM_SERVICE_DIR="/etc/systemd/system"
    ;;
  *)
    warn "Unknown distro: $DISTRO — proceeding with assumptions (pacman, apt, dnf, or zypper)"
    for pm in pacman apt-get dnf zypper; do
      if command -v "$pm" &>/dev/null; then
        PKG_MANAGER="$pm install -y"
        break
      fi
    done
    EARLYOOM_PKG="earlyoom"
    STRESS_PKG="stress-ng"
    ZRAM_SERVICE_DIR="/etc/systemd/system"
    ;;
esac

if [[ -z "${PKG_MANAGER:-}" ]]; then
  echo "ERROR: no supported package manager found" >&2
  exit 1
fi

# On Debian-based, update first
if [[ "$PKG_MANAGER" == "apt-get install -y" ]]; then
  info "Updating package list..."
  run apt-get update -qq
fi

# ---- Install packages ----
info "Installing packages..."
if [[ "$PKG_MANAGER" == pacman* ]]; then
  run pacman -Sy --noconfirm "$EARLYOOM_PKG" "$STRESS_PKG"
else
  run $PKG_MANAGER "$EARLYOOM_PKG" "$STRESS_PKG"
fi

# ---- Write config files ----
info "Writing config files..."

run install -Dm644 "$(dirname "$0")/etc/default/earlyoom"               "/etc/default/earlyoom"
run install -Dm644 "$(dirname "$0")/etc/sysctl.d/99-anti-freeze.conf"   "/etc/sysctl.d/99-anti-freeze.conf"
run install -Dm755 "$(dirname "$0")/usr/local/sbin/zram-setup.sh"       "/usr/local/sbin/zram-setup.sh"
run install -Dm755 "$(dirname "$0")/usr/local/sbin/zram-teardown.sh"    "/usr/local/sbin/zram-teardown.sh"
run install -Dm755 "$(dirname "$0")/usr/local/bin/anti-freeze-status"   "/usr/local/bin/anti-freeze-status"

# zram-swap.service: install to the right place
run install -Dm644 "$(dirname "$0")/etc/systemd/system/zram-swap.service" "$ZRAM_SERVICE_DIR/zram-swap.service"

# ---- Enable + start services ----
info "Enabling services..."
run systemctl daemon-reload
run systemctl enable earlyoom zram-swap
info "Starting services..."
run systemctl restart earlyoom zram-swap

# ---- Apply sysctl ----
info "Applying sysctl settings..."
run sysctl --system

# ---- Verify ----
ok "All done! Run 'anti-freeze-status' to verify, or 'stress-test.sh' to test."
echo ""
echo "  Emergency keys (SysRq = PrtSc):"
echo "    Alt + SysRq + f          — kill biggest memory hog"
echo "    Alt + SysRq + R E I S U B — safe reboot"
echo ""
echo "  Rollback:"
echo "    sudo systemctl disable --now earlyoom zram-swap"
echo "    sudo rm -f /etc/default/earlyoom"
echo "    sudo rm -f /etc/sysctl.d/99-anti-freeze.conf"
echo "    sudo rm -f /usr/local/sbin/zram-setup.sh"
echo "    sudo rm -f /usr/local/sbin/zram-teardown.sh"
echo "    sudo rm -f /usr/local/bin/anti-freeze-status"
echo "    sudo rm -f $ZRAM_SERVICE_DIR/zram-swap.service"
echo "    sudo sysctl --system"
