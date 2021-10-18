if [[ $- == *i* ]]; then
	function __git_status() {
		# setup a simple PROMPT/PS1
		BGREEN='\[\033[1;32m\]'
		BBLUE='\[\033[1;94m\]'
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

	[ -f ~/.fzf.bash ] && source ~/.fzf.bash
	[ -f ~/.aliases ] && source ~/.aliases
	[ -f ~/.localrc ] && source ~/.localrc

	# Set prompt with git
	__git_status

fi
