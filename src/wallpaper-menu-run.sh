#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

choice=$("$SCRIPT_DIR/wallpaper-menu.sh")

[ -z "$choice" ] && exit

"$SCRIPT_DIR/wallpaper.sh" "$choice"
