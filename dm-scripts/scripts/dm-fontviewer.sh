#!/bin/bash
#Dmenu script for viewing fonts

choice=$(fc-list | awk -F ':' '{ print $2 }'| sort | uniq | awk -F ',' '{print $NF}'| xargs -l | dmenu -l 20 -i -p "Fonts")
xdotool type "$choice"
