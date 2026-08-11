#!/bin/bash

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="/usr/bin"
LIB_DIR="/usr/lib/i3-wallpaper-rofi"

CONFIG_DIR="$HOME/.config/i3-wallpaper-rofi"
CONFIG_FILE="$CONFIG_DIR/config"

APP_DIR="$HOME/.local/share/applications"
AUTOSTART_DIR="$HOME/.config/autostart"

SUDOERS_FILE="/etc/sudoers.d/i3-wallpaper-rofi"

echo "== i3-wallpaper-rofi installer =="

# --------------------------------------------------
# Dependencies
# --------------------------------------------------

echo "[1/6] Checking dependencies..."

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

if ! command -v xwinwrap >/dev/null 2>&1; then
    echo
    echo "Missing dependency: xwinwrap"
    echo
    echo "xwinwrap is required by i3-video-wallpaper."
    echo "See:"
    echo "https://github.com/Zolyn/i3-video-wallpaper"
    exit 1
fi

echo "All dependencies found."

# --------------------------------------------------
# Install main scripts
# --------------------------------------------------

echo "[2/6] Installing scripts..."

sudo install -Dm755 \
    "$PROJECT_DIR/src/wallpaper" \
    "$BIN_DIR/wallpaper"

sudo install -Dm755 \
    "$PROJECT_DIR/src/wallpaper-menu-run" \
    "$BIN_DIR/wallpaper-menu-run"

sudo install -Dm755 \
    "$PROJECT_DIR/src/wallpaper-menu" \
    "$LIB_DIR/wallpaper-menu"

sudo install -Dm755 \
    "$PROJECT_DIR/src/wallpaper-scan" \
    "$LIB_DIR/wallpaper-scan"

sudo install -Dm755 \
    "$PROJECT_DIR/src/video-wallpaper" \
    "$LIB_DIR/video-wallpaper"

sudo install -Dm755 \
    "$PROJECT_DIR/src/update-lightdm-wallpaper" \
    "$LIB_DIR/update-lightdm-wallpaper"

# --------------------------------------------------
# Install i3-video-wallpaper
# --------------------------------------------------

echo "[3/6] Installing video wallpaper backend..."

VIDEO_BACKEND="$PROJECT_DIR/vendor/i3-video-wallpaper"

if [ ! -x "$VIDEO_BACKEND/setup.sh" ]; then
    echo
    echo "ERROR: i3-video-wallpaper submodule is missing."
    echo
    echo "Initialize it with:"
    echo
    echo "    git submodule update --init --recursive"
    echo
    exit 1
fi

sudo install -d "$LIB_DIR/i3-video-wallpaper"

sudo install -Dm755 \
    "$VIDEO_BACKEND/setup.sh" \
    "$LIB_DIR/i3-video-wallpaper/setup.sh"

sudo install -Dm644 \
    "$VIDEO_BACKEND/LICENSE" \
    "$LIB_DIR/i3-video-wallpaper/LICENSE"

sudo install -Dm644 \
    "$VIDEO_BACKEND/README.md" \
    "$LIB_DIR/i3-video-wallpaper/README.md"

# --------------------------------------------------
# Configuration
# --------------------------------------------------

echo "[4/6] Installing configuration..."

mkdir -p "$CONFIG_DIR"

if [ ! -f "$CONFIG_FILE" ]; then
    cp \
        "$PROJECT_DIR/config/config.example" \
        "$CONFIG_FILE"

    echo "Config created:"
    echo "  $CONFIG_FILE"
else
    echo "Config already exists, keeping it."
fi

# --------------------------------------------------
# Desktop integration
# --------------------------------------------------

echo "[5/6] Installing desktop integration..."

mkdir -p "$APP_DIR"
mkdir -p "$AUTOSTART_DIR"

install -Dm644 \
    "$PROJECT_DIR/desktop/wallpaper.desktop" \
    "$APP_DIR/wallpaper.desktop"

install -Dm644 \
    "$PROJECT_DIR/desktop/wallpaper-autostart.desktop" \
    "$AUTOSTART_DIR/wallpaper-autostart.desktop"

# --------------------------------------------------
# sudoers
# --------------------------------------------------

echo "[6/6] Configuring LightDM wallpaper permissions..."

echo "$USER ALL=(root) NOPASSWD: $LIB_DIR/update-lightdm-wallpaper" |
    sudo tee "$SUDOERS_FILE" >/dev/null

sudo chmod 440 "$SUDOERS_FILE"

echo
echo "======================================"
echo " i3-wallpaper-rofi installed!"
echo "======================================"
echo
echo "Config:"
echo "  $CONFIG_FILE"
echo
echo "Run:"
echo "  wallpaper-menu-run"
echo
