#!/bin/bash

set -e

echo "== Wallpaper uninstaller =="

sudo rm -f /usr/local/bin/wallpaper
sudo rm -f /usr/local/bin/wallpaper-menu
sudo rm -f /usr/local/bin/wallpaper-menu-run
sudo rm -f /usr/local/bin/wallpaper-scan
sudo rm -f /usr/local/bin/update-lightdm-wallpaper

rm -f \
    "$HOME/.local/share/applications/wallpaper.desktop"

rm -f \
    "$HOME/.config/autostart/wallpaper-autostart.desktop"

sudo rm -f /etc/sudoers.d/wallpaper

echo
echo "Configuration was NOT removed."

echo
echo "If you want to remove it too:"
echo "rm -rf ~/.config/wallpaper"

echo
echo "Done."
