#########################

# Path to the bash it configuration
export BASH_IT="$HOME/.local/bin/bash_it"

# If we do not have bash-it, install it.
if [ ! -d "$BASH_IT" ]; then
	git clone --depth=1 https://github.com/Bash-it/bash-it.git $BASH_IT
fi

export BASH_IT_THEME='pure'

# Load Bash It
source $BASH_IT/bash_it.sh
source $HOME/.aliases

# HISTORY SIZE
export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=100000                  # big big history
export HISTFILESIZE=100000              # big big history
shopt -s histappend                     # append to history, don't overwrite it

if [ "$(shopt | grep checkwinsize | awk '{print $2}')" = "off" ]; then
	shopt -s checkwinsize
fi

if [ "$EUID" -ne 0 ]; then
	if [ ! -S ~/.ssh/ssh_auth_sock ]; then
		eval $(ssh-agent)
		ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
	fi
	export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
	ssh-add -l | grep "The agent has no identities" && ssh-add
fi

# BASH COMPLETION
source /usr/share/bash-completion/bash_completion

# include custom files
if [ -f $HOME/.localrc ]; then
    source $HOME/.localrc
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
