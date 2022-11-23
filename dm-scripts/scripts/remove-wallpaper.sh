#!/bin/bash

file="/tmp/wallpaper.log"
if test -f "$file"; then

  source $file
  if [ -n $LAST_WALLPAPER ]; then 
    echo $LAST_WALLPAPER 
    rm $LAST_WALLPAPER
    notify-send "wallpaper removed" "file: $LAST_WALLPAPER"
  fi
fi
