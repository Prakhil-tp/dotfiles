
# ===========================================================================================================
#                                                         PROMPT
# ===========================================================================================================

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '\033[48;5;222m'
zstyle ':vcs_info:*' stagedstr '\033[48;5;222m'
zstyle ':vcs_info:git*' formats "%u%c  %b "
zstyle ':vcs_info:git:*' actionformats "\033[48;5;210m   %b | %a "
setopt prompt_subst

zsh_prompt_home_indicator() {
  if [[ "$PWD" = "$HOME" ]];then
    echo "  "
  else
    echo "  "
  fi
}

precmd() {
  bg_color='\033[48;5;183m'
  fg_color='\033[38;5;16m'
  clear='\033[m'
  #vcs_bg_color='\033[48;5;120m'
  vcs_bg_color='\033[48;5;159m'

  vcs_info
  print -P $bg_color$fg_color$(zsh_prompt_home_indicator)'%~ '$clear$vcs_bg_color$fg_color${vcs_info_msg_0_}$clear
}
PROMPT='▶ '

# ===========================================================================================================
#                                                      CONFIGS
# ===========================================================================================================
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$XDG_CACHE_HOME/zsh/history"

setopt autocd 

# basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots)

# automatically load bash completion functions
autoload -Uz bashcompinit && bashcompinit

#asdf config
. /opt/asdf-vm/asdf.sh

# time command output formatting
TIMEFMT=$'%J\n==================\nCPU\t%P\nuser\t%*U sec\nsystem\t%*S sec\ntotal\t%*E sec\n'

# Edit command in vim buffer ( Ctrl + e )
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
# ===========================================================================================================
#                                                         ALIAS
# ===========================================================================================================
# cleanup
alias mbsync="mbsync -c $XDG_CONFIG_HOME/isync/mbsyncrc"
alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"

# cleaned from $Home
alias zshrc="vim $ZDOTDIR/.zshrc"

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

#htop
alias h="htop"

#ls
alias ls='lsd -alh'
alias lt='ls --tree'

#math
alias math="bc <<<"

#pacman
alias pacman="sudo pacman"

#perl-rename
alias rename="perl-rename"

#vimwiki
alias wiki="nvim -c VimwikiIndex"

#neomutt
alias mail="neomutt"

# random
alias open="xdg-open"
alias iftop="sudo iftop"
alias docker="sudo docker"

#journalctl and systemctl
alias j="journalctl"
alias s="systemctl"

#config
alias ac="nvim ~/.config/awesome/rc.lua"
alias qc="nvim ~/.config/qutebrowser/config.py"
alias nc="nvim ~/.config/nvim/init.vim"

# ===========================================================================================================
#                                                 CUSTOM COMMANDS
# ===========================================================================================================
# so - command to search and open anyfile
function so() {
  file=$( \
    find $HOME -type f \
    ! -path '**/node_modules/*' \
    ! -path '**/[Cc]ache*/*' \
    ! -path '**/autoload/*' \
    ! -path '**/Code Cache/*' | \
    fzf -e \
  )
  xdg-open $file
}

# se - search and open a file to edit 
function se() {
    find $HOME/scripts $HOME/.config $HOME/dotfiles $HOME/documents \
    ! -path '**/node_modules/*' \
    ! -path '**/autoload/*' | \
    fzf -e | \
    xargs -r $EDITOR
}

# ===========================================================================================================
#                                                 PLUGINS & TOOLS 
# ===========================================================================================================
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $XDG_CONFIG_HOME/zsh/syntax-highlight-dracula.sh
source $XDG_DATA_HOME/fzf/fzf.zsh
source $ZDOTDIR/vim-mode.zsh

# ===========================================================================================================

# print system information on startup
paleofetch

