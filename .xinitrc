#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/usr/local/etc/X11/xinit/.Xresources
sysmodmap=/usr/local/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /usr/local/etc/X11/xinit/xinitrc.d ] ; then
	for f in /usr/local/etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

#some startup programs
nitrogen --set-zoom-fill --random ~/Media/wallpapers &
picom &

#for brightness
backlight 30

#tap on touchpad
synclient TapButton1=1
#detect palm
synclient PalmDetect=1

#for gsynaptics
#gsynaptics-init

#slstatus
slstatus 2>&1 >/dev/null &

#dwm loop
while true; do
	dwm >/dev/null 2>&1
done

exec dwm
