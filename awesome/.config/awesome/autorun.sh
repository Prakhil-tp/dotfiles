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
