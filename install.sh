#!/bin/bash

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "== Wallpaper installer =="

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
