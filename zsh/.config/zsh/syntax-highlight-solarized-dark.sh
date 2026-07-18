# Solarized Dark for zsh-syntax-highlighting
# Primary accent: yellow #b58900
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

## Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#586e75'

## Functions / commands
ZSH_HIGHLIGHT_STYLES[alias]='fg=#b58900'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#b58900'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#b58900'
ZSH_HIGHLIGHT_STYLES[function]='fg=#b58900'
ZSH_HIGHLIGHT_STYLES[command]='fg=#b58900'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#b58900,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#cb4b16,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#cb4b16'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#cb4b16'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#d33682'

## Builtins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#2aa198'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#2aa198'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#2aa198'

## Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#d33682'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#d33682'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#d33682'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#d33682'

## Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#cb4b16'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#cb4b16'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#cb4b16'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#dc322f'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#cb4b16'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#dc322f'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#cb4b16'

## Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#dc322f'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#839496'

## Misc
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#dc322f'
ZSH_HIGHLIGHT_STYLES[path]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#d33682'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#d33682'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#d33682'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#dc322f'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[default]='fg=#839496'
ZSH_HIGHLIGHT_STYLES[cursor]='standout'
