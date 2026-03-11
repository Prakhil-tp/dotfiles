#!/usr/bin/env bash

monitors=$(xrandr | grep -hoPe "[a-zA-Z]+[0-9-]+ connected" | awk 'BEGIN {ORS=" ";}{print $1}')
primary="HDMI1"
secondary="DP1"
tertiary="eDP1"


string_exists() {
  local target=$1
  local monitor_list=$2

  for element in $monitor_list; do
    if [ "$element" = "$target" ]; then
      return 0 # Return true if the string is found
    fi
  done
  return 1  # Return false if the string is not found
}


xrandr --output "$primary" --off
xrandr --output "$secondary" --off
xrandr --output "$tertiary" --off

xrandr --output "$primary" --auto
xrandr --output "$secondary" --auto
xrandr --output "$tertiary" --auto

if string_exists "$primary" "$monitors"; then
  xrandr --output "$primary" --primary
  xrandr --output "$tertiary" --mode "1920x1080" --right-of "$primary"
  # xrandr --output "$tertiary" --off 
  if string_exists "$secondary" "$monitors"; then
    xrandr --output "$secondary" --mode "1920x1080" --left-of "$primary"
  fi
elif string_exists "$secondary" "$monitors"; then 
  xrandr --output "$secondary" --mode "1920x1080" --primary
  xrandr --output "$tertiary" --mode "1920x1080" --right-of "$primary"
  # xrandr --output "$tertiary" --off 
fi
