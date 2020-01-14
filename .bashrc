if [[ $- == *i* ]]
then
    # Path to the bash it configuration
    if [ ! -d "$HOME/.local/bin/fzf" ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/bin/fzf"
        "$HOME/.local/bin/fzf/install" --all
    fi

    # HISTORY SIZE
    export HISTCONTROL=ignoredups:erasedups # no duplicate entries
    export HISTSIZE=100000                  # big big history
    export HISTFILESIZE=100000              # big big history
    shopt -s histappend                     # append to history, don't overwrite it
    export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'

    if [ "$(shopt | grep checkwinsize | awk '{print $2}')" = "off" ]; then
        shopt -s checkwinsize
    fi

    # include custom files
    if [ -f $HOME/.localrc ]; then
        source $HOME/.localrc
    fi
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash

    # setup a simple PROMPT/PS1
    export TERM="xterm-256color"
    BGREEN='\[\033[01;32m\]'
    BBLUE='\[\033[01;34m\]'
    PS_CLEAR='\[\033[0m\]'
    PS1="${BGREEN}\u@\h${BBLUE} \W \$${PS_CLEAR} "
fi
if [ -f $HOME/.aliases ]; then
    source $HOME/.aliases
fi
