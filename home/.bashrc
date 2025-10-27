[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -f /etc/bashrc ] && source /etc/bashrc
[ -f /etc/bash.bashrc ] && source /etc/bash.bashrc
[ -f "$HOME/.aliases" ] && source ~/.aliases
[ -f "$HOME/.localrc" ] && source "$HOME/.localrc"

# Path to the bash it configuration
if  [ ! -d "$HOME/.local/bin/fzf" ]; then
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
# Complete using arrow up/down
bind '"\e[A": history-search-backward' 2> /dev/null
bind '"\e[B": history-search-forward' 2> /dev/null
# PS1
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export PS1="${CONTAINER_ID:-$HOSTNAME}:\W\$ "

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
