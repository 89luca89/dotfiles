[ -f /etc/profile.d/bash_completion.sh ] && source /etc/profile.d/bash_completion.sh
[ -f /etc/bashrc ] && source /etc/bashrc
[ -f "$HOME/.aliases" ] && source ~/.aliases
[ -f "$HOME/.localrc" ] && source "$HOME/.localrc"

# Path to the bash it configuration
if  [ ! -d "$HOME/.local/bin/fzf" ]; then
	git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/bin/fzf"
	"$HOME/.local/bin/fzf/install" --all --no-completion
fi

# HISTORY SIZE
[ -z "$TMUX" ] && export TERM=xterm-256color
export HISTFILE="$HOME"/.histfile
export HISTCONTROL=ignoreboth:erasedups # no duplicate entries
export HISTSIZE=20000                 # big big history
export HISTFILESIZE=20000             # big big history
shopt -s histappend                   # append to history, don't overwrite it
shopt -s histreedit
shopt -s histverify
shopt -s cmdhist
# Complete using arrow up/down
bind '"\e[A": history-search-backward' 2> /dev/null
bind '"\e[B": history-search-forward' 2> /dev/null
bind 'set bind-tty-special-chars off' 2> /dev/null
bind '"\C-w": backward-kill-word' 2> /dev/null
# PS1
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}"'history -a; [ -n "$__hist_synced" ] && { history -c; history -r; }; __hist_synced=1'
export PS1="${CONTAINER_ID:+📦 }\W $ "

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
