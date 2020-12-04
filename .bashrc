if [[ $- == *i* ]]; then
	# Path to the bash it configuration
	if [ ! -d "$HOME/.local/bin/fzf" ]; then
		git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/bin/fzf"
		"$HOME/.local/bin/fzf/install" --all
	fi

	export EDITOR=vim

	# HISTORY SIZE
	export HISTFILE=~/.histfile
	export HISTCONTROL=ignoredups:erasedups # no duplicate entries
	export HISTSIZE=100000                  # big big history
	export HISTFILESIZE=100000              # big big history
	shopt -s histappend                     # append to history, don't overwrite it
	shopt -s histreedit
	shopt -s histverify
	shopt -s cmdhist

	export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'

	if [ "$(shopt | grep checkwinsize | awk '{print $2}')" = "off" ]; then
		shopt -s checkwinsize
	fi

	# include custom files
	if [ -f $HOME/.localrc ]; then
		source $HOME/.localrc
	fi
	[ -f ~/.fzf.bash ] && source ~/.fzf.bash

	if type rg &>/dev/null; then
		export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --no-ignore-vcs"
	fi

	# setup a simple PROMPT/PS1
	export TERM="xterm-256color"
	BGREEN='\[\033[01;32m\]'
	BBLUE='\[\033[01;34m\]'
	PS_CLEAR='\[\033[0m\]'
	PS1="${BGREEN}\u@\h${BBLUE} \W \$${PS_CLEAR} "

	# if [ ! -S ~/.ssh/ssh_auth_sock ]; then
	# 	eval $(ssh-agent)
	# 	ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
	# fi
	# export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
	# ssh-add -l >/dev/null || ssh-add
	# ssh-add -l >/dev/null || ssh-add ~/.ssh/id_rsa_ext

fi
if [ -f $HOME/.aliases ]; then
	source $HOME/.aliases
fi
