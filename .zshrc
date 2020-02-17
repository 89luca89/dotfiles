ZSH_DISABLE_COMPFIX=true
bindkey -e
bindkey "^[[1;5D" emacs-backward-word
bindkey "^[[1;5C" emacs-forward-word
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
# Auto install plugins if missing
export ZSH=$HOME/.local/bin/zsh
if [ ! -d "$HOME/.local/bin/fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/bin/fzf"
    "$HOME/.local/bin/fzf/install" --all
fi
source $HOME/.aliases
# Manage history
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt NO_HIST_VERIFY
setopt APPEND_HISTORY                       # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY     # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS                 # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# include custom files
if [ -f $HOME/.localrc ]; then
    source $HOME/.localrc
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# use tmux split with FZF
if [ "${TMUX}" ]; then
    export FZF_TMUX=1
fi
# Manage the ssh keys
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    ssh-add ~/.ssh/id_rsa
    ssh-add ~/.ssh/id_rsa_ext
fi

# PROMPT
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green}*%f'
zstyle ':vcs_info:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:git:*' formats '%F{yellow}(%b%f%c%u%F{yellow})'
zstyle ':vcs_info:git:*' actionformats '%F{yellow}(%b (%a)%f%c%u%F{yellow})'
setopt PROMPT_PERCENT
setopt PROMPT_SUBST
PROMPT='%B%F{green}%n@%m:%F{blue}%30<..<%~%f%<< %b$vcs_info_msg_0_%b%b%F{white}$ '
