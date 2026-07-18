source $ZDOTDIR/syntax-highlight-dracula.sh
export FZF_DEFAULT_OPTS="--color=fg:#f8f8f2,hl:#bd93f9 --color=fg+:#f8f8f2,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --layout=reverse --height 40%"
_THEME_PROMPT_BG='\033[48;2;189;147;249m'     # #bd93f9 purple (primary)
_THEME_PROMPT_FG='\033[38;2;40;42;54m'        # #282a36 bg
_THEME_VCS_BG='\033[48;255;184;108m'           # #ffb86c orange
_THEME_VCS_UNSTAGED='\033[48;241;250;140m'    # #f1fa8c yellow
_THEME_VCS_STAGED='\033[48;80;250;123m'        # #50fa7b green
_THEME_VCS_ACTION='\033[48;255;85;85m'         # #ff5555 red
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6272a4'
