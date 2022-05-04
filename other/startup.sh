#!/bin/sh

killall trayer
killall nm-applet

nitrogen --restore

trayer --edge top --align right --SetDockType true --SetPartialStrut true  --expand true --width 5 --transparent true --tint 0x5f5f5f --height 20 &

xsetroot -cursor_name left_ptr

if [ -x /usr/bin/nm-applet ] ; then
   nm-applet --sm-disable &
fi
