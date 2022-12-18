# NVM (Node Version Manager)

nvm allows you to quickly install and use different versions of node via commandline.

## Installation

You should run install-script to install the nvm.

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
```

## Configuration

**nvm** slows down the initial launch of your shell (zsh/bash). Because it runs loading scripts on every startup of your shell.

To fix that there's workaround. reference: https://github.com/nvm-sh/nvm/issues/1261#issuecomment-585252279

Add the following script to `~/.nvm/` directory. It helps to only loads the nvm whenever we need it.

```
~/.nvm/loadnvm.sh
-------------------------------------
#!/bin/zsh

#delete the aliases
unalias nvm
unalias npm
unalias node

#(this is the loader code nvm put in my .bashrc)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

Put these aliases to your `~/.zshrc`

```
# nvm
alias nvm='. ~/.nvm/loadnvm.sh; nvm "$@"'
alias npm='. ~/.nvm/loadnvm.sh; npm "$@"'
alias node='. ~/.nvm/loadnvm.sh; node "$@"'
```

