#!/bin/bash

set -e

echo "🚀 Installing dotfiles..."

# Get current repo directory (IMPORTANT FIX)
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$HOME/.config"
BIN="$HOME/.local/bin"

mkdir -p "$CONFIG"
mkdir -p "$BIN"

# -----------------------
# Install dependencies
# -----------------------

echo "📦 Installing dependencies..."

if command -v pacman >/dev/null 2>&1; then

    # Official packages
    sudo pacman -S --needed \
        hyprland waybar rofi kitty fish \
        imagemagick swww mpv python-pywal \
        brightnessctl playerctl \
        networkmanager bluez bluez-utils bluetuith

    # Install yay if not present (AUR helper)
    if ! command -v yay >/dev/null 2>&1; then
        echo "📦 Installing yay (AUR helper)..."
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
    fi

    # Install mpvpaper from AUR
    echo "📦 Installing mpvpaper..."
    yay -S --needed mpvpaper

else
    echo "⚠️ Unsupported distro. Install manually."
fi

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
# Cache
# -----------------------

echo "📁 Creating cache..."
mkdir -p "$HOME/.cache/wallthumbs"

# -----------------------
# Verify important tools
# -----------------------

echo "🔍 Verifying setup..."

command -v mpvpaper >/dev/null || echo "❌ mpvpaper not found"
command -v wal >/dev/null || echo "❌ pywal not found"
command -v rofi >/dev/null || echo "❌ rofi not found"

echo "✅ Setup complete!"
