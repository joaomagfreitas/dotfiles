#!/usr/bin/env bash

# fail on exit code
set -euo pipefail

# absolute path to dotfiles folder
dotfiles="$(realpath $(dirname "$0"))"

set_avatar() {
    sudo tee "/var/lib/AccountsService/users/$USER" < "$dotfiles/.config/user/avatar.conf" > /dev/null
    sudo tee "/var/lib/AccountsService/icons/$USER" < "$dotfiles/.config/user/avatar.icon" > /dev/null
    sudo tee "/var/lib/AccountsService/icons/avatar" < "$dotfiles/.config/user/avatar.icon" > /dev/null
}

set_wallpaper() {
    wallpaper=$(realpath  "$dotfiles/.config/user/wallpaper.jpeg")
    wallpaper_system="/usr/share/wallpapers/wallpaper.jpeg"

    sudo tee "$wallpaper_system" < "$wallpaper" > /dev/null

    # Desktop
    plasma-apply-wallpaperimage "$wallpaper"
    
    # Lock screen
    kwriteconfig6 --file kscreenlockerrc \
        --group Greeter \
        --group Wallpaper \
        --group org.kde.image \
        --group General \
        --key Image "$wallpaper"

    # Login manager
    sudo kwriteconfig6 --file /etc/plasmalogin.conf \
        --group Greeter \
        --group Wallpaper \
        --group org.kde.image \
        --group General \
        --key Image "$wallpaper_system"
}

set_font() {
    kwriteconfig6 --file kdeglobals --group General --key font "SF Pro Text,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    kwriteconfig6 --file kdeglobals --group General --key menuFont "SF Pro Text,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    kwriteconfig6 --file kdeglobals --group General --key toolBarFont "SF Pro Text,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    kwriteconfig6 --file kdeglobals --group General --key smallestReadableFont "SF Pro Text,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    kwriteconfig6 --file kdeglobals --group General --key fixed "SF Pro Text,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    kwriteconfig6 --file kdeglobals --group WM --key activeFont "SF Pro Text,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
}

set_aliases() {
    expander='[ -d ~/.config/aliases ] && for f in ~/.config/aliases/*; do [ -f "$f" ] && source "$f"; done'
    if ! grep -Fxq "$expander" ~/.bashrc; then
        echo "$expander" >> ~/.bashrc
    fi

    mkdir -p ~/.config/aliases
    cp "$dotfiles/.config/aliases"/* ~/.config/aliases
}

set_git_config() {
    cp "$dotfiles/.config/git/user.conf" ~/.gitconfig
}

# set_kwin_scritpts() {
    
# }

# set_java() {
#     expander='[ -d ~/.config/java ] && for f in ~/.config/java/*; do [ -f "$f" ] && source "$f"; done'
#     if ! grep -Fxq "$expander" ~/.bashrc; then
#         echo "$expander" >> ~/.bashrc
#     fi

#     mkdir -p ~/.config/java
#     cp "$dotfiles/.config/java"/* ~/.config/java
# }


set_grub_theme() {
    theme="/usr/share/grub/themes/fluent"
    sudo cp -dir "$dotfiles/third_party/hyperfluent-grub/linux-generic" /usr/share/grub/themes/

    if ! grep -q "GRUB_THEME='$theme/theme.txt'" /etc/default/grub; then
        echo "GRUB_THEME='$theme/theme.txt'" >> /etc/default/grub
    fi

    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

set_theme() {
    # Task bar icon
    kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc \
        --group Containments \
        --group 98 \
        --group Applets \
        --group 99 \
        --group Configuration \
        --group General \
        --key icon "$dotfiles/.config/plasma/taskbar.icon"
}

# set_avatar
# set_wallpaper
# set_font
# set_aliases
# set_git_config

set_theme

# dirs=(".config/awesome" ".config/rofi" ".config/picom" ".config/alacritty" ".config/aliases" ".config/glance" ".local/bin" ".fonts/")
# files=(".face")

# for dir in ${dirs[@]}; do
#     sudo mount --bind ~/$dir/ $dir
# done
