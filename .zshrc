ZSH_DISABLE_COMPFIX=true
# If we do not have ohmyzsh, install it.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	git clone https://github.com/robbyrussell/oh-my-zsh $HOME/.oh-my-zsh
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Zsh completion
fpath=(/usr/local/share/zsh-completions $fpath)

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it ll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="philips"
#ZSH_THEME="risto"
#ZSH_THEME="pygmalion"
#ZSH_THEME="lukerandall"
#ZSH_THEME="gnzh"
ZSH_THEME="luca-linux"
# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ssh-agent assh zsh-autosuggestions history history-substring-search zsh-syntax-highlighting dnf)

source $ZSH/oh-my-zsh.sh

# BASIC ALIASES
alias grep='grep --color'
alias ls='ls -Ah --group-directories-first --color'
alias ll='ls -Ahl --group-directories-first --color'
alias tree='tree -C'
alias top='top -o %CPU'
alias open='xdg-open'
alias gcc='gcc -Wall -Wextra -lm'

alias rambox='ssh -N -X -C -c aes128-ctr yoga "rambox"'

# add openvpn
alias start-vpn="sudo openvpn /home/luca-linux/.cert/nm-openvpn/77.109.150.195-combined.ovpn"

# TMUX SHORTCUTS
alias newsock='tmux -S /tmp/tmux-1000/tmux-session-$(date "+%d-%m-%y-%H-%M")'
alias sock1-create='tmux -S /tmp/tmux-1000/session-1'
alias sock2-create='tmux -S /tmp/tmux-1000/session-2'
alias sock3-create='tmux -S /tmp/tmux-1000/session-3'
alias sock1-attach='tmux -S /tmp/tmux-1000/session-1 attach'
alias sock2-attach='tmux -S /tmp/tmux-1000/session-2 attach'
alias sock3-attach='tmux -S /tmp/tmux-1000/session-3 attach'

# PATH
export PATH=$HOME/bin:$PATH
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export ANDROID_HOME=/home/luca-linux/Programs/android-sdk-linux
export LC_ALL=en_US.UTF-8
#export GOPATH=/usr/local/go
export GOPATH=$HOME/.local/go
#export GOROOT=/usr/bin/go
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$HOME/.local/bin:$PATH

NPM_PACKAGES="${HOME}/.npm-packages"

PATH="$PATH:$NPM_PACKAGES/bin"

# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

alias ssh='assh wrapper ssh'

[ -f $HOME/.zsh-history-substring-search.zsh ] && source $HOME/.zsh-history-substring-search.zsh

SAVEHIST=100000

# include custom files
if [ -f $HOME/.localrc ]; then
    source $HOME/.localrc
fi
if [ "${TMUX}" ]; then
    export FZF_TMUX=1
fi
# add support for ctrl+o to open selected file in vim
#export FZF_DEFAULT_COMMAND="find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
#    -o -type f -print \
#    -o -type d -print \
#    -o -type l -print 2> /dev/null | cut -b3-"
#export FZF_DEFAULT_OPTS="--bind='enter:execute(xdg-open {1}; sleep 1s)+abort' --preview 'if [ -d {1} ]; then ls -laH {1}; elif file {1} | grep text; then pygmentize -g {1} ; fi'"
#export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(myGvim {1} > /dev/null 2>&1 &)' --preview 'if [ -d {1} ]; then ls -laH {1}; elif file {1} | grep text; then pygmentize -g {1} ; fi'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
