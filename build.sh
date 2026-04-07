#!/bin/bash

set -e

echo "🚀 Setting up Laksh rice..."

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$HOME/.config"
BIN="$HOME/.local/bin"

mkdir -p "$CONFIG"
mkdir -p "$BIN"

# -----------------------
# Install pacman packages
# -----------------------

echo "📦 Installing core packages..."

sudo pacman -S --needed \
  hyprland waybar rofi kitty fish \
  thunar \
  fastfetch starship \
  brightnessctl playerctl \
  networkmanager bluez bluez-utils bluetuith \
  wl-clipboard cliphist \
  grim slurp hyprshot \
  imagemagick mpv \
  python-pywal \
  adw-gtk-theme papirus-icon-theme \
  ttf-jetbrains-mono-nerd

# -----------------------
# Install yay (AUR helper)
# -----------------------

if ! command -v yay >/dev/null 2>&1; then
    echo "📦 Installing yay..."

    sudo pacman -S --needed git base-devel

    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd ~

    echo "✅ yay installed"
fi

# -----------------------
# Install AUR packages
# -----------------------

echo "📦 Installing AUR packages..."

yay -S --needed mpvpaper swww

# -----------------------
# Enable services
# -----------------------

echo "🔌 Enabling services..."

sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# -----------------------
# Copy configs
# -----------------------

echo "📁 Copying configs..."

cp -r "$DOTFILES/.config/"* "$CONFIG/"

# -----------------------
# Copy scripts
# -----------------------

echo "⚙️ Copying scripts..."

cp "$DOTFILES/bin/"* "$BIN/" 2>/dev/null || true
chmod +x "$BIN/"* 2>/dev/null || true

# -----------------------
# Setup cache + wal fallback
# -----------------------

echo "🎨 Setting up colors..."

mkdir -p "$HOME/.cache/wallthumbs"

# fallback wallpaper (IMPORTANT)
if [ ! -f "$HOME/.cache/wal/colors" ]; then
    echo "⚠️ No wal colors found, generating default..."

    DEFAULT_WALL="/usr/share/backgrounds/archlinux/archlinux.png"

    if [ -f "$DEFAULT_WALL" ]; then
        wal -i "$DEFAULT_WALL"
    else
        echo "⚠️ No default wallpaper found, skipping wal"
    fi
fi

# -----------------------
# Fix font cache (icons issue)
# -----------------------

echo "🔤 Refreshing fonts..."

fc-cache -fv

# -----------------------
# Done
# -----------------------

echo "✅ Setup complete!"
echo "👉 Reboot or relogin recommended"
