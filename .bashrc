if [[ $- == *i* ]]; then
	# Path to the bash it configuration
	if [ ! -d "$HOME/.local/bin/fzf" ]; then
		git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/bin/fzf"
		"$HOME/.local/bin/fzf/install" --all
	fi
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
	# Complete using arrow up/down
    bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'

	if [ "$(shopt | grep checkwinsize | awk '{print $2}')" = "off" ]; then
		shopt -s checkwinsize
	fi

	# setup a simple PROMPT/PS1
	BGREEN='\[\033[01;32m\]'
	BBLUE='\[\033[01;34m\]'
	PS_CLEAR='\[\033[0m\]'
	PS1="${BGREEN}\u@\h${BBLUE} \W \$${PS_CLEAR} "

	# include custom files
	if [ -f "$HOME/.localrc" ]; then
		source ~/.localrc
	fi
	[ -f ~/.fzf.bash ] && source ~/.fzf.bash
	# use tmux split with FZF
	if [ "${TMUX}" ]; then
		export FZF_TMUX=1
	fi

fi

if [ -f ~/.aliases ]; then
	source ~/.aliases
fi
