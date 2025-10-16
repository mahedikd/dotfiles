#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="$HOME/dotfiles/backup"
DOTFILES_REPO="https://github.com/mahedikd/dotfiles"

if [[ ! -d "$BACKUP_DIR" ]]; then
  echo "❌ Backup directory not found at $BACKUP_DIR"
  exit 1
fi

echo "🚀 Starting full system restore..."

echo "🔧 Updating system..."
sudo pacman -Syu --noconfirm

echo "📦 Installing packages..."
sudo pacman -S --needed - < "$BACKUP_DIR/pkglist.txt"

echo "📦 Installing AUR packages..."
if [[ -f "$BACKUP_DIR/aurlist.txt" ]]; then
  if ! command -v yay &>/dev/null; then
    echo "⚙️ Installing yay..."
    sudo pacman -S --noconfirm yay
  fi
  yay -S --needed - < "$BACKUP_DIR/aurlist.txt"
fi

echo "⚙️ Enabling system services..."
while read -r service; do
  [[ -z "$service" || "$service" == "UNIT" ]] && continue
  sudo systemctl enable --now "$service" || true
done < "$BACKUP_DIR/enabled-services.txt"

echo "🐳 Setting up Docker..."
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
newgrp docker <<EONG
echo "✅ User added to docker group."
EONG

echo "📦 Installing Distrobox if missing..."
if ! command -v distrobox &>/dev/null; then
  sudo pacman -S --needed --noconfirm distrobox docker
fi

echo "💾 Cloning and stowing dotfiles..."
if [[ -n "${DOTFILES_REPO:-}" ]]; then
  git clone "$DOTFILES_REPO" ~/.dotfiles
  cd ~/.dotfiles
  stow .
fi

echo "✅ Restore complete! Reboot to fully activate docker group membership."
