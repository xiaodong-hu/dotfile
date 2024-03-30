#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

# Launch bar1 and bar2

polybar top-eDP1 &
polybar bottom-eDP1 &

# polybar top-DP3 & 
# polybar bottom-DP3 &

echo "Bars launched..."
