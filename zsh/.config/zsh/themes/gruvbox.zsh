source $ZDOTDIR/syntax-highlight-gruvbox.sh
export FZF_DEFAULT_OPTS="--color=bg+:#3c3836,bg:#282828,fg:#ebdbb2,fg+:#ebdbb2 --color=hl:#d79921,hl+:#d79921,info:#d79921,prompt:#d79921 --color=pointer:#d79921,marker:#83a598,spinner:#8ec07c,header:#83a598 --layout=reverse --height 40%"
_THEME_PROMPT_BG='\033[48;2;215;153;33m'   # #d79921 neutral_yellow (primary)
_THEME_PROMPT_FG='\033[38;2;40;40;40m'     # #282828 dark0
_THEME_VCS_BG='\033[48;2;131;165;152m'     # #83a598 bright_blue
_THEME_VCS_UNSTAGED='\033[48;2;250;189;47m' # #fabd2f bright_yellow
_THEME_VCS_STAGED='\033[48;2;184;187;38m'   # #b8bb26 bright_green
_THEME_VCS_ACTION='\033[48;2;251;73;52m'    # #fb4934 bright_red
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#928374'
