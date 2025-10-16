#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="$HOME/dotfiles/backup"

mkdir -p "$BACKUP_DIR"

echo "📦 Exporting installed package lists..."
pacman -Qqe > "$BACKUP_DIR/pkglist.txt"

if command -v yay &>/dev/null; then
  yay -Qqm > "$BACKUP_DIR/aurlist.txt"
else
  echo "⚠️  yay not found, skipping AUR list"
fi

echo "🗂️ Saving enabled system services..."
systemctl list-unit-files --state=enabled \
  | awk 'NR>1 {print $1}' > "$BACKUP_DIR/enabled-services.txt"


echo "✅ Export complete! Files in $BACKUP_DIR"
