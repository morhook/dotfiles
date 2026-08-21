#!/bin/bash

echo autodetecting the midi port of \"Q49 MKII\"
# leggo
midi_secondary=$(aseqdump -l | grep Transport | grep Q49 | awk '{print $1}')

echo detected midi_secondary in port \"$midi_secondary\"
# throttle + trailing: emit at most once per INTERVAL during a sweep,
# and always apply the final value when input goes quiet.
throttle_volume() {
	local INTERVAL=0.1
	local val="" pending=0
	while true; do
		if IFS= read -r -t "$INTERVAL" line; then
			# new value within the window -> remember it, don't fire yet
			val="$line"; pending=1
		else
			# window elapsed with no new input -> flush latest
			if [ "$pending" -eq 1 ]; then
				playerctl volume "$val"
				pending=0
			fi
		fi
	done
}

aseqdump -p "Q49 MKII" | awk '/Control change         15, controller 7/ {system(sprintf("pactl set-sink-volume @DEFAULT_SINK@ %.2f", $8 / 127))}
/Control change         15, controller 1/ {print $8/127; fflush()}' | throttle_volume &


aseqdump -p $midi_secondary | awk '/Note off                0, note 93/ {system("playerctl stop")}
/Note off                0, note 94/ {system("playerctl play-pause")}
/Note off                0, note 98/ {system("playerctl previous")}
/Note off                0, note 99/ {system("playerctl next")}' &


# ended=false
# trap 'echo "SIGTERM detected"; kill %1; kill %2; ended=true' SIGTERM;
# trap 'echo "SIGINT detected"; kill %1; kill %2; ended=true' SIGINT;

# while ! $ended; do
# 	sleep 2;
# done
wait
