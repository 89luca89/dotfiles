if [[ $- == *i* ]]; then
	# Path to the bash it configuration
	if [ ! -d "$HOME/.local/bin/fzf" ]; then
		git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/bin/fzf"
		"$HOME/.local/bin/fzf/install" --all
	fi
	# HISTORY SIZE
	export HISTFILE="$HOME"/.histfile
	export HISTCONTROL=ignoredups:erasedups # no duplicate entries
	export HISTSIZE=100000                  # big big history
	export HISTFILESIZE=100000              # big big history
	shopt -s histappend                     # append to history, don't overwrite it
	shopt -s histreedit
	shopt -s histverify
	shopt -s cmdhist

	# export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r; __git_status"
	# export PROMPT_COMMAND="$PROMPT_COMMAND; history -a"
	# Complete using arrow up/down
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'

	[ -f ~/.fzf.bash ] && source ~/.fzf.bash
	[ -f ~/.aliases ] && source ~/.aliases
	[ -f ~/.localrc ] && source ~/.localrc
fi
