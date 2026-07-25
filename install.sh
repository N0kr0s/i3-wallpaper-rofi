#!/bin/bash

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "== Wallpaper installer =="

# ----------------------------
# Dependencies
# ----------------------------

echo "[0/6] Checking dependencies..."

require() {

    if ! command -v "$1" >/dev/null 2>&1; then
        echo
        echo "Missing dependency: $1"
        echo "Please install it and run install.sh again."
        exit 1
    fi

}

require feh
require ffmpeg
require convert
require rofi
require mpv
require xrandr
require xdotool
require socat
require pkill
require install

# xwinwrap
if ! command -v xwinwrap >/dev/null 2>&1; then
    echo
    echo "Missing dependency: xwinwrap"
    echo
    echo "Install it from:"
    echo "https://github.com/Zolyn/i3-video-wallpaper"
    exit 1
fi

echo "All dependencies found."

# ----------------------------
# Install scripts
# ----------------------------

echo "[1/6] Installing scripts..."

sudo install -Dm755 "$PROJECT_DIR/src/wallpaper" \
    /usr/local/bin/wallpaper

sudo install -Dm755 "$PROJECT_DIR/src/wallpaper-menu" \
    /usr/local/bin/wallpaper-menu

sudo install -Dm755 "$PROJECT_DIR/src/wallpaper-menu-run" \
    /usr/local/bin/wallpaper-menu-run

sudo install -Dm755 "$PROJECT_DIR/src/wallpaper-scan" \
    /usr/local/bin/wallpaper-scan

sudo install -Dm755 "$PROJECT_DIR/src/update-lightdm-wallpaper" \
    /usr/local/bin/update-lightdm-wallpaper

# ----------------------------
# i3-video-wallpaper
# ----------------------------

echo "[1.5/6] Installing video wallpaper engine..."

if [ ! -f "$PROJECT_DIR/i3-video-wallpaper/setup.sh" ]; then
    echo "ERROR: Missing i3-video-wallpaper/setup.sh"
    exit 1
fi

sudo install -Dm755 \
    "$PROJECT_DIR/i3-video-wallpaper/setup.sh" \
    /usr/local/lib/i3-wallpaper-rofi/setup.sh

# ----------------------------
# Config
# ----------------------------

echo "[2/6] Installing config..."

mkdir -p "$HOME/.config/wallpaper"

if [ ! -f "$HOME/.config/wallpaper/wallpaper.conf" ]; then

    cp \
        "$PROJECT_DIR/config/wallpaper.conf.example" \
        "$HOME/.config/wallpaper/wallpaper.conf"

    echo "Config created."

else

    echo "Config already exists."

fi

# ----------------------------
# Desktop entry
# ----------------------------

echo "[3/6] Installing desktop entry..."

mkdir -p "$HOME/.local/share/applications"

cp \
    "$PROJECT_DIR/desktop/wallpaper.desktop" \
    "$HOME/.local/share/applications/"

# ----------------------------
# Autostart
# ----------------------------

echo "[4/6] Installing autostart..."

mkdir -p "$HOME/.config/autostart"

cp \
    "$PROJECT_DIR/desktop/wallpaper-autostart.desktop" \
    "$HOME/.config/autostart/"

# ----------------------------
# sudoers
# ----------------------------

echo "[5/6] Installing sudo rule..."

echo "$USER ALL=(root) NOPASSWD: /usr/local/bin/update-lightdm-wallpaper" |
sudo tee /etc/sudoers.d/wallpaper >/dev/null

sudo chmod 440 /etc/sudoers.d/wallpaper

# ----------------------------
# Finish
# ----------------------------

echo "[6/6] Done."

echo
echo "Wallpaper installed successfully."
