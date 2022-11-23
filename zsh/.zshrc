
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="▶ "
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_DIR_HOME_BACKGROUND="246"
POWERLEVEL9K_DIR_HOME_FOREGROUND="black"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="246"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="black"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="238"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="black"
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=''
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=''
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"

plugins=(
	git
	nvm
	zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

if [ -f ~/.zsh/syntax-highlight-dracula.sh ]; then
    source ~/.zsh/syntax-highlight-dracula.sh
else
    print "404: ~/.zsh/syntax-highlight-dracula.sh not found."
fi


# time command output formatting
TIMEFMT=$'%J\n==================\nCPU\t%P\nuser\t%*U sec\nsystem\t%*S sec\ntotal\t%*E sec\n'

# ===========================================================================================================
# 																												ALIAS
# ===========================================================================================================
#
alias projects="pushd ~/code/projects && clear && ls"
alias playground="pushd ~/code/playground && clear && ls"
alias notes="pushd ~/documents/notes && clear && ls"

alias ..="cd ../ && clear && ls"
alias vim="nvim"
alias vimdiff="nvim -d"
alias cat="bat"

#vifm
alias vifm="~/.config/vifm/scripts/vifmrun"
alias v="~/.config/vifm/scripts/vifmrun"

#ls
alias ls='lsd -alh'
alias lt='ls --tree'

#math
alias math="bc <<<"

#pacman
alias pacman="sudo pacman"

#perl-rename
alias rename="perl-rename"

# Exa 
#alias ls='exa -al --color=always --group-directories-first' # my preferred listing
#alias la='exa -a --color=always --group-directories-first'  # all files and dirs
#alias ll='exa -l --color=always --group-directories-first'  # long format
#alias lt='exa -aT --color=always --group-directories-first' # tree listing
#alias l.='exa -a | egrep "^\."'

# ===========================================================================================================
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

# ===========================================================================================================

# fzf config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# print system information on startup
neofetch

