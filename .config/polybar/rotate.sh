#!/bin/bash

# obtain the current rotation status
rotation="$(xrandr -q --verbose | grep 'connected' | egrep -o  '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"

case "$rotation" in
	normal) 
	# rotate to the left
	xrandr -o right 
    i3-msg reload

    # see xsetwacom list for connected devices
	xsetwacom set 12 rotate cw
	xsetwacom set 13 rotate cw
	xsetwacom set 19 rotate cw
	;;
	right)
	xrandr -o normal
    i3-msg reload

    xsetwacom set 12 rotate none 
	xsetwacom set 13 rotate none 
	xsetwacom set 19 rotate none 
	;;
esac
