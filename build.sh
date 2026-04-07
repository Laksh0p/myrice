#!/bin/bash

set -e

echo "🚀 Installing dotfiles..."

DOTFILES="$HOME/dotfiles"
CONFIG="$HOME/.config"
BIN="$HOME/.local/bin"

mkdir -p "$CONFIG"
mkdir -p "$BIN"

# -----------------------
# Install dependencies
# -----------------------

echo "📦 Installing dependencies..."

if command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed \
        hyprland waybar rofi kitty fish \
        imagemagick swww mpvpaper python-pywal \
        brightnessctl playerctl \
        networkmanager bluez bluez-utils bluetuith
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

echo "✅ Setup complete!"
