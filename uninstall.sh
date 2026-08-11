#!/bin/bash

set -e

BIN_DIR="/usr/bin"
LIB_DIR="/usr/lib/i3-wallpaper-rofi"

CONFIG_DIR="$HOME/.config/i3-wallpaper-rofi"
STATE_DIR="$HOME/.local/state/i3-wallpaper-rofi"
DATA_DIR="$HOME/.local/share/i3-wallpaper-rofi"

APP_DIR="$HOME/.local/share/applications"
AUTOSTART_DIR="$HOME/.config/autostart"

SUDOERS_FILE="/etc/sudoers.d/i3-wallpaper-rofi"

echo "== i3-wallpaper-rofi uninstaller =="

echo "[1/4] Removing executables..."

sudo rm -f \
    "$BIN_DIR/wallpaper" \
    "$BIN_DIR/wallpaper-menu-run"

echo "[2/4] Removing application files..."

sudo rm -rf "$LIB_DIR"

rm -f \
    "$APP_DIR/wallpaper.desktop" \
    "$AUTOSTART_DIR/wallpaper-autostart.desktop"

echo "[3/4] Removing sudo rule..."

sudo rm -f "$SUDOERS_FILE"

echo "[4/4] Removing runtime data..."

rm -rf "$STATE_DIR"
rm -rf "$DATA_DIR"

echo
echo "Configuration was NOT removed:"
echo "  $CONFIG_DIR"
echo
echo "To remove the configuration manually:"
echo "  rm -rf \"$CONFIG_DIR\""
echo
echo "i3-wallpaper-rofi has been uninstalled."
