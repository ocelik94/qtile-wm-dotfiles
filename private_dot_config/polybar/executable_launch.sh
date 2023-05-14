#!/usr/bin/env bash

## Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
INTERFACE="$(ip link | awk '/state UP/ {print $2}' | tr -d :)"
RFILE="$DIR/.module"

# Fix backlight and network modules
fix_modules() {
	if [[ "$INTERFACE" == e* ]]; then
		sed -i -e 's/network/ethernet/g' "$DIR"/config.ini
	fi
}

# Launch the bar
launch_bar() {
	# Terminate already running bar instances
	killall -q polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	# Launch the bar
	for mon in $(polybar --list-monitors | cut -d":" -f1); do
		MONITOR=$mon polybar main -c "$DIR"/config.ini 2>blub.log &
	done
}

# Execute functions
if [[ ! -f "$RFILE" ]]; then
	fix_modules
	touch "$RFILE"
fi	
launch_bar
