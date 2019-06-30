import os
import re

# terminate all already running bar instances
os.system('killall -q polybar')

# wait until the processes have been shut down
os.system('while pgrp -u $UID -x polybar > /dev/null; do sleep 1; done')

# Launch polybars

monitor = os.popen('xrandr | head -2 | tail -n 1').read()[:5]

os.system('MONITOR='+monitor+' polybar top &')
os.system('MONITOR='+monitor+' polybar bottom &')

os.system('echo "Polybars Launched..."')
