# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
. "$CARGO_HOME/env" 2>/dev/null || true


# path
export PATH="$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/scripts:$PATH"

# xdg environment variables
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export EDITOR="nvim"
export BROWSER="qutebrowser"

# clipmenu
export CM_SELECTIONS="clipboard"
export CM_DEBUG=0
export CM_OUTPUT_CLIP=1
export CM_MAX_CLIPS=10

# fzf colors are set per-theme in $ZDOTDIR/current-theme.zsh

# cleanup
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export ASDF_DIR="$XDG_DATA_HOME/asdf-lib"
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdrc"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="$XDG_CONFIG_HOME/asdf/tool-versions"

# cargo/rustup
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# bun
export BUN_INSTALL="$XDG_DATA_HOME/bun"

# .NET
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"

# yarn
export YARN_GLOBAL_FOLDER="$XDG_DATA_HOME/yarn"
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"

# nuget
export NUGET_PACKAGES="$XDG_DATA_HOME/NuGet/packages"
export NUGET_HTTP_CACHE_PATH="$XDG_CACHE_HOME/NuGet"

# claude code config dir (sessions, projects, data)
export CLAUDE_CONFIG_DIR="$XDG_DATA_HOME/claude"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export MBSYNCRC="$XDG_CONFIG_HOME/isync/mbsyncrc"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export HISTFILE="$XDG_CACHE_HOME/zsh/history"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

. "$HOME/.local/share/../bin/env"

# misc
export VIMINFO_FILE="$XDG_STATE_HOME/vim/viminfo"
