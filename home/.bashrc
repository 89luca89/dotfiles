[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -f /etc/bashrc ] && source /etc/bashrc
[ -f /etc/bash.bashrc ] && source /etc/bash.bashrc
[ -f "$HOME/.aliases" ] && source ~/.aliases

function workbox() {
	if pwd | grep -q chainguard && [ "${CONTAINER_ID}" != "wolfi_distrobox" ] && [ "${OVERRIDE:-}" != "1" ]; then
		distrobox enter wolfi_distrobox
	fi
}

if [ -e /run/.containerenv ]; then
	# Path to the bash it configuration
	if [ ! -d "$HOME/.local/bin/fzf" ]; then
		git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/bin/fzf"
		"$HOME/.local/bin/fzf/install" --all
	fi
	# HISTORY SIZE
	export HISTFILE="$HOME"/.histfile
	export HISTCONTROL=ignoredups:erasedups # no duplicate entries
	export HISTSIZE=100000                # big big history
	export HISTFILESIZE=100000            # big big history
	shopt -s histappend                   # append to history, don't overwrite it
	shopt -s histreedit
	shopt -s histverify
	shopt -s cmdhist

	export PROMPT_COMMAND="workbox;${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
	# Complete using arrow up/down
	bind '"\e[A": history-search-backward' 2> /dev/null
	bind '"\e[B": history-search-forward' 2> /dev/null

	[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"

	BGREEN='\[\033[1;32m\]'
	BLUE='\[\e[38;5;39m\]'
	BBLUE='\[\033[1;94m\]'
	RED='\[\033[91m\]'
	ORANGE='\[\e[38;5;208m\]'
	PS_CLEAR='\[\033[0m\]'
	export PS1=${BLUE}'\u'${PS_CLEAR}'@'${ORANGE}'$CONTAINER_ID'${PS_CLEAR}':'${BBLUE}'\W'${PS_CLEAR}'$ '
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f "$HOME/.localrc" ] && source "$HOME/.localrc"
