# Just the default polybar script with some stuff changed.
#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1, -r flag used to reload whenever changes are made 
polybar default -r &

echo "Bars launched..."

