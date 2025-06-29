#!/bin/sh

run() {
  case $1 in
    "sudo")
      if ! pgrep -f "$2" ;
      then
        "${@:1}"
      fi
      ;;
    *)
      if ! pgrep -f "$1" ;
      then
        "$@"
      fi
      ;;
  esac
}

run conky -c /home/prakhil/.config/conky/dracula-without-gpu.conkyrc > /dev/null 2>&1 &
run keynav
# run sudo -b openvpn /home/prakhil/.config/openvpn/client.ovpn
# xset r rate 200 80 # for fast key-press
xset r rate 300 50 # for fast key-press
