#!/bin/sh

export DISPLAY=:0 #initializing the display for CRON job support
wallpaper_path="/home/prakhil/Pictures/wallpapers"
list=( `ls -w1 $wallpaper_path | grep "[a-zA-Z0-9-]*\.\(jpg\|png\)"` )
list_length=${#list[@]}
let "number = $RANDOM % $list_length"
let "last_num=`cat $wallpaper_path/.last`"
while [ $last_num == $number ]; do
  let "number = $RANDOM % $list_length"
done
echo $number > $wallpaper_path/.last
#nitrogen --set-scaled --save $WALLPAPERS/${ALIST[$number]}
feh --bg-fill $wallpaper_path/${list[$number]}
echo "LAST_WALLPAPER=\"$wallpaper_path/${list[$number]}\"" > /tmp/wallpaper.log
exit 
