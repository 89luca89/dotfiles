if [[ $- == *i* ]]; then
	# Path to the bash it configuration
	if [ ! -d "$HOME/.local/bin/fzf" ]; then
		git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/bin/fzf"
		"$HOME/.local/bin/fzf/install" --all
	fi
	if [ ! -f "$HOME/.local/bin/.git-prompt.sh" ]; then
		curl -o "$HOME/.local/bin/.git-prompt.sh" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
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

	source "$HOME/.local/bin/.git-prompt.sh"

	# setup a simple PROMPT/PS1
	BGREEN='\[\033[01;32m\]'
	BBLUE='\[\033[01;34m\]'
	RED='\[\033[01;30m\]'
	PS_CLEAR='\[\033[0m\]'



	export GIT_PS1_SHOWDIRTYSTATE=1
	export GIT_PS1_SHOWSTASHSTATE=1
	export GIT_PS1_SHOWUNTRACKEDFILES=1
	export GIT_PS1_SHOWCOLORHINTS=1
	export PS1=${BGREEN}'\u@\h'${PS_CLEAR}':'${BBLUE}'\w'${PS_CLEAR}${RED}'$(__git_ps1)'${PS_CLEAR}' $ '

	[ -f ~/.fzf.bash ] && source ~/.fzf.bash
	# use tmux split with FZF
	if [ "${TMUX}" ]; then
		export FZF_TMUX=1
	fi

fi

if [ -f ~/.aliases ]; then
	source ~/.aliases
fi

# include custom files
if [ -f "$HOME/.localrc" ]; then
	source ~/.localrc
fi

if [ ! -z $DISPLAY ]; then
	xgamma -gamma 0.9 2>/dev/null
	setxkbmap -layout us -variant altgr-intl
	setxkbmap -option ctrl:nocaps
	# xinput set-prop 12 "$(xinput list-props 12 | grep "Click Method Enabled" | head -n1 | grep -Eo "([0-9][0-9][0-9])")" {0,1}
	# xinput set-prop 12 "$(xinput list-props 12 | grep "Tapping Enabled" | head -n1 | grep -Eo "([0-9][0-9][0-9])")" 1
fi
