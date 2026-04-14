#!/usr/bin/env bash

# fail on exit code
set -euo pipefail

# absolute path to fonts folder
fonts="$(realpath $(dirname "$0"))"

download_sf_pro() {
    tmp_dir=$(mktemp -d)

    (
        cd "$tmp_dir";
        wget 'https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg' -O sf-pro.pkg;
        7z x sf-pro.pkg 
        7z x 'SFProFonts/SF Pro Fonts.pkg'
        7z x 'SFProFonts.pkg/Payload'
        7z x Payload~
        mv "$tmp_dir/Library/Fonts" ~/.local/share/fonts/SF-Pro
    )
}

download_sf_pro
fc-cache -rv
