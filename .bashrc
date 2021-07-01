if [[ $- == *i* ]]; then
	function __git_status() {
		# setup a simple PROMPT/PS1
		BGREEN=''
		BBLUE='\[\033[94m\]'
		RED='\[\033[91m\]'
		PS_CLEAR='\[\033[0m\]'
		STATUS=$(git status 2>/dev/null || echo "norepo")
		BRANCH=$(echo $STATUS | grep -oP 'branch\s\K.*' | cut -d' ' -f1)
		SYMBOL=$(echo $STATUS | grep -q "not staged" && echo "*")
		SYMBOL_2=$(echo $STATUS | grep -q "Untracked" && echo "%")
		if [ "$STATUS" == "norepo" ]; then
			export PS1=${BGREEN}'\u@\h'${PS_CLEAR}':'${BBLUE}'\w'${PS_CLEAR}' $ '
		else
			export PS1=${BGREEN}'\u@\h'${PS_CLEAR}':'${BBLUE}'\w'${PS_CLEAR}${RED}" [${BRANCH}${SYMBOL}${SYMBOL_2}]"${PS_CLEAR}' $ '
		fi
	}
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

	export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r; __git_status"
	# Complete using arrow up/down
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'

	if [ -f "$HOME"/.fzf.bash ]; then
		source "$HOME/.fzf.bash"
	fi
	# use tmux split with FZF
	if [ "${TMUX}" ]; then
		export FZF_TMUX=1
	fi

	if [ -f "$HOME"/.aliases ]; then
		source "$HOME"/.aliases
	fi

	# include custom files
	if [ -f "$HOME/.localrc" ]; then
		source "$HOME/.localrc"
	fi

	# Set prompt with git
	__git_status

fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
