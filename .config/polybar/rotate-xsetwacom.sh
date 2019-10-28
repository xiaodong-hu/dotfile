#!/bin/sh

# see https://github.com/linuxwacom/xf86-input-wacom/wiki/Rotation

# Find the line in "xrandr -q --verbose" output that contains current screen orientation and "strip" out current orientation.

rotation="$(xrandr -q --verbose | grep 'connected' | egrep -o  '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"

# Using current screen orientation proceed to rotate screen and input devices.


# see for wacom device names (id)
# xsetwacom list devices

case "$rotation" in
    normal)
    # rotate to the left
    xrandr -o left
    xsetwacom set 11 rotate ccw
    xsetwacom set 17 rotate ccw
    xsetwacom set 10 rotate ccw
    ;;
    left)
    # rotate to inverted
    xrandr -o inverted
    xsetwacom set 11 rotate half
    xsetwacom set 17 rotate half
    xsetwacom set 10 rotate half
    ;;
    inverted)
    # rotate to the right
    xrandr -o right
    xsetwacom set 11 rotate cw
    xsetwacom set 17 rotate cw
    xsetwacom set 10 rotate cw
    ;;
    right)
    # rotate to normal
    xrandr -o normal
    xsetwacom set 11 rotate none
    xsetwacom set 17 rotate none
    xsetwacom set 10 rotate none
    ;;
esac