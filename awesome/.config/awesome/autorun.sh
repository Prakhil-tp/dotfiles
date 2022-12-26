#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"
  fi
}

run conky -c ~/.config/conky/dracula.conkyrc
