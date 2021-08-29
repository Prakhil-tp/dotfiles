#! /bin/bash
#using the path WALLPAPERS will select a new random wallpaper
WALLPAPERS="/home/prakhil/Pictures/backgrounds"
ALIST=( `ls -w1 $WALLPAPERS` )
RANGE=${#ALIST[@]}
let "number = $RANDOM"
let LASTNUM="`cat $WALLPAPERS/.last` + $number"
let "number = $LASTNUM % $RANGE"
echo $number > $WALLPAPERS/.last
nitrogen --set-scaled --save $WALLPAPERS/${ALIST[$number]}
exit 
