#!/bin/sh

rotation="$(xrandr -q --verbose | grep 'connected' | egrep -o  '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"

case "$rotation" in
	normal) 
	# rotate to the left
	xrandr -o right
	xsetwacom set 11 rotate cw
	xsetwacom set 17 rotate cw
	xsetwacom set 10 rotate cw
	;;
	right)
	xrandr -o normal
	xsetwacom set 11 rotate none
	xsetwacom set 17 rotate none
	xsetwacom set 10 rotate none
	;;
esac