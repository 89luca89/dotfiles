#########################

# Path to the bash it configuration
export BASH_IT="$HOME/.local/bin/bash_it"

# If we do not have bash-it, install it.
if [ ! -d "$BASH_IT" ]; then
	git clone --depth=1 https://github.com/Bash-it/bash-it.git $BASH_IT
fi

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='pure'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true
export SCM_GIT_SHOW_REMOTE_INFO=true

# Load Bash It
source $BASH_IT/bash_it.sh

#########################
#########################

# HISTORY SIZE
export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=100000                  # big big history
export HISTFILESIZE=100000              # big big history
shopt -s histappend                     # append to history, don't overwrite it
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

if [ "$(shopt | grep checkwinsize | awk '{print $2}')" = "off" ]; then
	shopt -s checkwinsize
fi

# BASIC ALIASES
alias grep='grep --color'
alias ls='ls -Ah --group-directories-first --color'
alias ll='ls -Ahl --group-directories-first --color'
alias tree='tree -C'
alias top='top -o %CPU'
alias open='xdg-open'

# TMUX SHORTCUTS
alias newsock='tmux -S /tmp/tmux-1000/tmux-session-$(date "+%d-%m-%y-%H-%M")'
alias sock1-create='tmux -S /tmp/tmux-1000/session-1'
alias sock2-create='tmux -S /tmp/tmux-1000/session-2'
alias sock3-create='tmux -S /tmp/tmux-1000/session-3'
alias sock1-attach='tmux -S /tmp/tmux-1000/session-1 attach'
alias sock2-attach='tmux -S /tmp/tmux-1000/session-2 attach'
alias sock3-attach='tmux -S /tmp/tmux-1000/session-3 attach'

# Only if not root.
if [ "$EUID" -ne 0 ]; then
	# START SSH AGENT
	if [ ! -S ~/.ssh/ssh_auth_sock ]; then
		eval $(ssh-agent)
		ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
	fi
	export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
	ssh-add -l | grep "The agent has no identities" && ssh-add
fi
# PATH
export PATH=$HOME/Desktop/android-sdk-linux/platform-tools:$PATH
export PATH=$HOME/bin:$PATH
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export ANDROID_HOME=$HOME/Desktop/android-sdk-linux/
export LC_ALL=en_US.UTF-8
export GOPATH=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

alias ssh='assh wrapper ssh'

# BASH COMPLETION
source /usr/share/bash-completion/bash_completion

# include custom files
if [ -f $HOME/.localrc ]; then
    source $HOME/.localrc
fi

# Launch only if not running
#if [ ! $(ps -ef | grep "syndaemon" | grep -v grep | awk '{ print $2}') ]; then syndaemon -i 0.5 -K -R -d 2> /dev/null ; fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
