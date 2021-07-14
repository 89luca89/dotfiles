ZSH_DISABLE_COMPFIX=true
bindkey -e
bindkey "^[[1;5D" emacs-backward-word
bindkey "^[[1;5C" emacs-forward-word
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word
bindkey "^H" backward-delete-word
# Auto install plugins if missing
export ZSH=$HOME/.local/bin/zsh
if [ ! -d "$ZSH" ]; then
    mkdir -p $ZSH/plugins
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/plugins/zsh-syntax-highlighting
fi
if [ ! -d "$HOME/.local/bin/fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/bin/fzf"
    "$HOME/.local/bin/fzf/install" --all
fi

# Manage history
unsetopt EXTENDEDHISTORY
SAVEHIST=100000
HISTFILE=~/.histfile
setopt NO_HIST_VERIFY
setopt APPEND_HISTORY                       # adds history
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY     # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS                 # don't record dupes in history
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt nullglob
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# use tmux split with FZF
if [ "${TMUX}" ]; then
    export FZF_TMUX=1
fi
# Zsh completion
fpath=(/usr/local/share/zsh-completions $fpath)
source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.aliases

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

# include custom files
if [ -f $HOME/.localrc ]; then
    source $HOME/.localrc
fi
