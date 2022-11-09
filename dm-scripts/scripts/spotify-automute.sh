#!/bin/bash
#
# Author: prakhl-tp
#
# Mute spotify when it starts advertisement
#
# Launch with or after spotify. This script automatically exits when spotify window is closed
#
# nohup ./spotify-automute.sh > /tmp/spotify-automute.log &
# or
# ./spotify-automute.sh

# wait 10sec for spotify to Launch
sleep 10

# VAR
AD_MUTED=0
AD_DETECTED=0

# FCT
mute_player() {
  num=$(pactl list | grep -E '(^Sink Input)|(media.name = \"Spotify\"$)' | awk '/Spotify/ {print a} {a = $0}' | cut -c 13- | tail -n 1)
  pactl set-sink-input-mute $num yes
}

unmute_player() {
  num=$(pactl list | grep -E '(^Sink Input)|(media.name = \"Spotify\"$)' | awk '/Spotify/ {print a} {a = $0}' | cut -c 13- | tail -n 1)
  pactl set-sink-input-mute $num no
}

log() {
  local line=${1}
  echo \[$( date "+%H:%M:%S" )\] $line
}

# Unmute just in case this script crashed the previous time
unmute_player

# Find window id
WM_ID=$(xdotool search --class "spotify" | sed -n 2p)

log "Spotify automute launched!"

# Runs until spotify window is closed
while [ -n "$WM_ID" ]; do

  is_it_playing=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
                  /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
                  string:'org.mpris.MediaPlayer2.Player' \
                  string:'PlaybackStatus' |grep 'variant' |awk '{printf $NF}'|sed s/\"//g)

  # Main: mutiing 
  if [[ $is_it_playing = "Playing" ]]; then

      DBUS_TRACKDATA="$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 \
      org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | grep xesam:title -A 1 | grep variant | cut -d \" -f 2)"

      if [[ "$DBUS_TRACKDATA" =~ ^(Advertisement|Spotify)$ ]]; then
        log "AD detected"
        AD_DETECTED="1"
      else
          AD_DETECTED="0"
      fi

       #Debug (uncomment if you need to debug the script)
       #echo "DBUS: \"$DBUS_TRACKDATA\""
       #echo "Debug: AD_MUTED = $AD_MUTED, AD_DETECTED = $AD_DETECTED"

      if [[ "$AD_DETECTED" = "0" ]] && [[ "$AD_MUTED" = "1" ]]; then
        log "Unmuting (AD_MUTED = $AD_MUTED, AD_DETECTED = $AD_DETECTED)"
        sleep 2
        unmute_player
        AD_MUTED="0"
        log "Unmuted"
      elif [[ "$AD_DETECTED" = "1" ]] && [[ "$AD_MUTED" = "0" ]]; then
        log "Muting (AD_MUTED = $AD_MUTED, AD_DETECTED = $AD_DETECTED)"
        mute_player
        AD_MUTED="1"
        log "Muted"
      fi
      
  fi

  # check is spotify window still exist
  WM_ID=$(xdotool search --class "spotify" | sed -n 2p)
  sleep 1
done

log "Spotify is not active, Exiting"
exit 1

