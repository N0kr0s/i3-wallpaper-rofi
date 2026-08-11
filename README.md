# i3-wallpaper-rofi

A lightweight wallpaper manager for **i3wm** with a Rofi-based interface.

`i3-wallpaper-rofi` allows you to quickly switch between image and video wallpapers, keep the selected wallpaper between sessions, and optionally update the **LightDM** *(others are planned)* login screen wallpaper.

<img width="639" height="288" alt="rofi" src="https://github.com/user-attachments/assets/c4085e72-b4ec-4975-bb76-a157d857ba99" />

## Features

* Image wallpapers: PNG, JPG, JPEG, WebP
* Video wallpapers: MP4, WebM, MKV
* Rofi-based wallpaper selector
* Restore the last selected wallpaper after login
* Persistent wallpaper state
* Multi-monitor support through the video wallpaper backend
* Configurable Rofi theme, prompt and icons
* Optional LightDM wallpaper synchronization
* Simple installation and uninstallation scripts
* Video wallpaper backend included as a Git submodule

## Requirements

The following applications are required:

* Bash
* feh
* ffmpeg
* ImageMagick (`convert`)
* Rofi
* mpv
* xrandr
* xdotool
* socat
* xwinwrap

The installer checks for required dependencies automatically.

## Installation

Clone the repository:

```bash
git clone --recurse-submodules https://github.com/N0kr0s/i3-wallpaper-rofi.git
cd i3-wallpaper-rofi
```

If the repository was cloned without submodules:

```bash
git submodule update --init --recursive
```

Run the installer:

```bash
./install.sh
```

The installer installs the application to:

```text
/usr/bin/
    wallpaper
    wallpaper-menu-run

/usr/lib/i3-wallpaper-rofi/
    wallpaper-menu
    wallpaper-scan
    video-wallpaper
    update-lightdm-wallpaper
    i3-video-wallpaper/
```

User configuration is stored in:

```text
~/.config/i3-wallpaper-rofi/config
```

## Usage

Open the wallpaper selector:

```bash
wallpaper-menu-run
```

You can also restore the previously selected wallpaper manually:

```bash
wallpaper restore
```

The selected wallpaper is stored in:

```text
~/.local/state/i3-wallpaper-rofi/wallpaper
```

A preview image used for LightDM synchronization is stored in:

```text
~/.local/share/i3-wallpaper-rofi/current.png
```

## Configuration

The default configuration is created automatically during installation.

Example:

```bash
IMAGE_DIRS=(
    "$HOME/Pictures/wallpapers"
)

VIDEO_DIRS=(
    "$HOME/Video"
    "$HOME/Video/wallpapers"
)

VIDEO_BACKEND="/usr/lib/i3-wallpaper-rofi/video-wallpaper"

SHOW_ICONS=true

IMAGE_ICON="󰈟 "
VIDEO_ICON="󰈈 "

ROFI_THEME="gruvbox-dark"
ROFI_PROMPT="Wallpaper"
ROFI_MESSAGE="Select wallpaper"

SORT_MODE="name"
```

### Wallpaper directories

Add directories containing your wallpapers to `IMAGE_DIRS` and `VIDEO_DIRS`.

Only files in the supported formats are scanned.

### Rofi appearance

You can customize the selector using:

```bash
ROFI_THEME="gruvbox-dark"
ROFI_PROMPT="Wallpaper"
ROFI_MESSAGE="Select wallpaper"
```

Icons can be enabled or disabled with:

```bash
SHOW_ICONS=true
```

### Sorting

Wallpapers can be sorted by name, path, or left in filesystem order:

```bash
SORT_MODE="name"
```

Available modes:

* `name`
* `path`
* `none`

## How it works

The project is split into several small components:

```text
Rofi
  │
  ▼
wallpaper-menu-run
  │
  ▼
wallpaper-menu
  │
  ▼
wallpaper-scan
  │
  ▼
wallpaper
  ├── image → feh
  │
  └── video → video-wallpaper
                    │
                    ▼
               xwinwrap + mpv
```

The selected wallpaper is saved to a small state file, allowing it to be restored automatically on the next login.

The video wallpaper functionality is provided by the included [`i3-video-wallpaper`](https://github.com/Zolyn/i3-video-wallpaper) backend.

## Autostart

The installer creates a desktop autostart entry:

```text
~/.config/autostart/wallpaper-autostart.desktop
```

It runs:

```bash
/usr/bin/wallpaper restore
```

This restores the last selected wallpaper when the desktop session starts.

## LightDM integration

`i3-wallpaper-rofi` can update the LightDM login screen using the generated wallpaper preview.

The installer creates a dedicated sudoers rule allowing only the wallpaper update utility to run with elevated privileges.

```text
/etc/sudoers.d/i3-wallpaper-rofi
```

No general passwordless root access is granted.

## Uninstallation

Run:

```bash
./uninstall.sh
```

The uninstaller removes the installed binaries, backend, desktop integration, sudoers rule and runtime data.

The user configuration is intentionally preserved:

```text
~/.config/i3-wallpaper-rofi
```

To remove it manually:

```bash
rm -rf ~/.config/i3-wallpaper-rofi
```

## Project structure

```text
i3-wallpaper-rofi/
├── config/
│   └── config.example
├── desktop/
│   ├── wallpaper-autostart.desktop
│   └── wallpaper.desktop
├── src/
│   ├── wallpaper
│   ├── wallpaper-menu
│   ├── wallpaper-menu-run
│   ├── wallpaper-scan
│   ├── video-wallpaper
│   ├── update-lightdm-wallpaper
│   └── update-lockscreen.sh
├── vendor/
│   └── i3-video-wallpaper/
├── install.sh
└── uninstall.sh
```

## License

[MIT](https://mit-license.org)

This project is licensed under the terms of the license included in this repository.

## Credits

Video wallpaper functionality is based on [`i3-video-wallpaper`](https://github.com/Zolyn/i3-video-wallpaper).

---

Made for Linux desktops running **i3wm + Rofi**.
