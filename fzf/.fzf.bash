# Setup fzf
# ---------
if [[ ! "$PATH" == */home/prakhil/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/prakhil/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/prakhil/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/prakhil/.fzf/shell/key-bindings.bash"
