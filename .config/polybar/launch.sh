#!/usr/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

# Launch top and bottom bars
# polybar top-eDP1 &
# polybar bottom-eDP1 &
# polybar top-DP3 & 
# polybar bottom-DP3 &

if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar top &
        MONITOR=$m polybar bottom &
    done
else
    MONITOR=$m polybar top &
    MONITOR=$m polybar bottom &
fi



echo "Bars launched..."
