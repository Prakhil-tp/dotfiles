#!/bin/sh


xrandr --output "HDMI1" --primary --mode 1920x1080
sleep 2
xrandr --output DisplayPort-0 --mode 2560x1440 --rate 165
sleep 1
echo 'awesome.restart()' | awesome-client
