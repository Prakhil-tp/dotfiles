export PATH="/home/blue/.local/share/asdf/shims:$PATH"
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

. "$HOME/.local/share/../bin/env"

# keep history out of $HOME (HISTFILE in env points at zsh history)
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/bash"
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"
