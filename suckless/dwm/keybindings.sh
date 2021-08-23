#!/bin/sh

sed -n '/MyKeyBindings/,/EndBindings/p' ~/.config/suckless/dwm/config.def.h | grep -e '/*' | grep -v '};' | grep -v '//E' | sed -e 's/^[ \t{]*/\t/' -e 's/\/\/Group/\n/' | yad --text-info --geometry=700x740

