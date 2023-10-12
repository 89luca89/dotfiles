[  -f /etc/bashrc ] && source /etc/bashrc
[  -f ~/.aliases ] && source ~/.aliases

if [ ! -z $CONTAINER_ID ]; then
	# Path to the bash it configuration
	if [ ! -d "$HOME/.local/bin/fzf" ]; then
		git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/bin/fzf"
		"$HOME/.local/bin/fzf/install" --all
	fi
	# HISTORY SIZE
	export HISTFILE="$HOME"/.histfile
	export HISTCONTROL=ignoredups:erasedups # no duplicate entries
	export HISTSIZE=100000 # big big history
	export HISTFILESIZE=100000 # big big history
	shopt -s histappend # append to history, don't overwrite it
	shopt -s histreedit
	shopt -s histverify
	shopt -s cmdhist

	export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
	# Complete using arrow up/down
	bind '"\e[A": history-search-backward' 2> /dev/null
	bind '"\e[B": history-search-forward' 2> /dev/null

	killall -9 gnome-software 2> /dev/null

	[ -f ~/.fzf.bash ] && source ~/.fzf.bash
	[ -f ~/.localrc ] && source ~/.localrc
	BGREEN='\[\033[1;32m\]'
	BLUE='\[\e[38;5;39m\]'
	BBLUE='\[\033[1;94m\]'
	RED='\[\033[91m\]'
	ORANGE='\[\e[38;5;208m\]'
	PS_CLEAR='\[\033[0m\]'
	export PS1=${BLUE}'\u'${PS_CLEAR}'@'${ORANGE}'\h'${PS_CLEAR}':'${BBLUE}'\W'${PS_CLEAR}'$ '
fi
