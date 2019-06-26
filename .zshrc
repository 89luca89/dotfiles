ZSH_DISABLE_COMPFIX=true
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.local/bin/oh-my-zsh

# If we do not have ohmyzsh, install it.
if [ ! -d "$ZSH" ]; then
	git clone https://github.com/robbyrussell/oh-my-zsh $ZSH
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
fi
if [ ! -d "$HOME/.local/bin/fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/bin/fzf"
    "$HOME/.local/bin/fzf/install" --all
fi
# Zsh completion
fpath=(/usr/local/share/zsh-completions $fpath)

ZSH_THEME="gnzh"
CASE_SENSITIVE="true"

plugins=(git ssh-agent zsh-autosuggestions history history-substring-search zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source $HOME/.aliases

[ -f $HOME/.zsh-history-substring-search.zsh ] && source $HOME/.zsh-history-substring-search.zsh

SAVEHIST=100000
setopt NO_HIST_VERIFY
setopt APPEND_HISTORY                       # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY     # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS                 # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# include custom files
if [ -f $HOME/.localrc ]; then
    source $HOME/.localrc
fi
if [ "${TMUX}" ]; then
    export FZF_TMUX=1
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
