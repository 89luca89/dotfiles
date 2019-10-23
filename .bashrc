# Path to the bash it configuration
export BASH_IT="$HOME/.local/bin/bash_it"

# If we do not have bash-it, install it.
if [ ! -d "$BASH_IT" ]; then
	git clone --depth=1 https://github.com/Bash-it/bash-it.git $BASH_IT
fi
if [ ! -d "$HOME/.local/bin/fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/bin/fzf"
    "$HOME/.local/bin/fzf/install" --all
fi

export BASH_IT_THEME='pure'

# Load Bash It
source $BASH_IT/bash_it.sh
source $HOME/.aliases

if [ ! -d "$BASH_IT/.initialized" ]; then
    bash-it enable plugin alias-completion base dirs fzf git history proxy ssh sshagent tmux 
    bash-it enable completion bash-it dirs export defaults git makefile pip pip3 ssh tmux
    mkdir "$BASH_IT/.initialized"
fi

# HISTORY SIZE
export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=100000                  # big big history
export HISTFILESIZE=100000              # big big history
shopt -s histappend                     # append to history, don't overwrite it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

if [ "$(shopt | grep checkwinsize | awk '{print $2}')" = "off" ]; then
	shopt -s checkwinsize
fi

# BASH COMPLETION
source /usr/share/bash-completion/bash_completion

# include custom files
if [ -f $HOME/.localrc ]; then
    source $HOME/.localrc
fi
if [ "${TMUX}" ]; then
    export FZF_TMUX=1
fi

if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    for key in $HOME/.ssh/id_*; do
        echo $key
        ssh-add $key
    done
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
