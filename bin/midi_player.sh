#!/bin/bash

echo autodetecting the midi port of \"Q49 MKII\"
# leggo
midi_secondary=$(aseqdump -l | grep Transport | grep Q49 | awk '{print $1}')

echo detected midi_secondary in port \"$midi_secondary\"
aseqdump -p "Q49 MKII" | awk '/Control change         15, controller 7/ {system("playerctl volume " $8/127 )}' >> /tmp/midi.log &

aseqdump -p $midi_secondary | awk '/Note off                0, note 93/ {system("playerctl stop")}
/Note off                0, note 94/ {system("playerctl play-pause")}
/Note off                0, note 98/ {system("playerctl previous")}
/Note off                0, note 99/ {system("playerctl next")}' &


ended=false
trap 'echo "SIGTERM detected"; kill %1; kill %2; ended=true' SIGTERM;
trap 'echo "SIGINT detected"; kill %1; kill %2; ended=true' SIGINT;

while ! $ended; do
	sleep 2;
done
