#!/bin/sh

killall trayer
killall nm-applet
killall polkit-gnome-authentication-agent-1

nitrogen --restore

trayer --edge top --align right --SetDockType true --SetPartialStrut true  --expand true --width 5 --transparent true --tint 0x5f5f5f --height 20 &
/usr/libexec/polkit-gnome-authentication-agent-1 &

xsetroot -cursor_name left_ptr

if [ -x /usr/bin/nm-applet ] ; then
   nm-applet --sm-disable &
fi

xset -dpms
xset s off # if you also want to disable the screen saver
