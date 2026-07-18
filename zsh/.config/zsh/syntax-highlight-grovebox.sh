# Grovebox (Gruvbox Dark) for zsh-syntax-highlighting
# Primary accent: neutral_yellow #d79921
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

## Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#928374'

## Functions / commands
ZSH_HIGHLIGHT_STYLES[alias]='fg=#d79921'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#d79921'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#d79921'
ZSH_HIGHLIGHT_STYLES[function]='fg=#d79921'
ZSH_HIGHLIGHT_STYLES[command]='fg=#d79921'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#d79921,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#fabd2f,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fabd2f'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fabd2f'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#d3869b'

## Builtins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#8ec07c'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8ec07c'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#8ec07c'

## Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#d3869b'

## Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#fabd2f'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#fabd2f'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#fabd2f'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#fb4934'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#fabd2f'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#fb4934'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#fabd2f'

## Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#fb4934'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#ebdbb2'

## Misc
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#fb4934'
ZSH_HIGHLIGHT_STYLES[path]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#fb4934'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[default]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[cursor]='standout'
