# Setup fzf
# ---------
if [[ ! "$PATH" == *$XDG_DATA_HOME/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$XDG_DATA_HOME/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$XDG_DATA_HOME/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$XDG_DATA_HOME/fzf/shell/key-bindings.bash"
