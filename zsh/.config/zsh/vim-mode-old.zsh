#!/bin/sh

# enable vim mode to terminal
# Change cursor shape according to the mode in terminal
zle-keymap-select () {
  if [ $KEYMAP = vicmd ]; then
    echo -ne '\e[1 q'
  else
    echo -ne '\e[6 q'
  fi
}

zle -N zle-keymap-select

# Start with beam shape cursor on every new line
zle-line-init () {
  zle -K viins
  echo -ne '\e[6 q'
}

zle -N zle-line-init

bindkey -v
export KEYTIMEOUT=1
