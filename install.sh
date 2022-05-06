#!/bin/sh

WALLPAPERS=$HOME/Wallpapers

## Script to install window manager!

alias zypper='sudo zypper --non-interactive'

addrepo() {
  REPOS=$(zypper lr -u | grep -Eo 'http(s)?://.+' | tr -d '/')
  REPO=$(grep -Eo '.+/' <<< $1 | tr -d '/')
  [[ $REPOS == *$REPO* ]] || zypper ar $1
}


## Determin OS:
OS=$(cat /etc/os-release | grep -E '^ID=' | tail -c +4 | tr -d '"')

if [[ $OS == *tumbleweed* ]]; then
  addrepo https://download.opensuse.org/repositories/X11:Utilities/openSUSE_Tumbleweed/X11:Utilities.repo
else
  addrepo https://download.opensuse.org/repositories/X11:Utilities/\$releasever/X11:Utilities.repo
fi

zypper ref
zypper in rofi xmonad xmobar gmp-devel ncurses-devel NetworkManager-applet curl nitrogen

## GHC up

command -v ghcup || curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

## symlinks
mkdir -p ~/.config/rofi
ln -s $PWD/other/rofi-config.rasi $HOME/.config/rofi/config.rasi

if [[ $PWD != $HOME/.config/xmonad ]]; then
  [[ -d $HOME/.config/xmonad ]] && rm -fr $HOME/.config/xmonad
  ln -s $PWD $HOME/.config/xmonad
fi

## Wallpapers
mkdir -p $WALLPAPERS
cp other/wallpaper.png $WALLPAPERS/opensuse.png

nitrogen --set-centered $WALLPAPERS/opensuse.png
