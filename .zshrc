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
ZSH_THEME="lukerandall"

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

alias ssh-forward='ssh -f -N -T -R 8002:localhost:8001 luca-linux@52.178.38.238'
# PATH
export PATH=$HOME/Desktop/android-sdk-linux/platform-tools:$PATH
export PATH=$HOME/bin:$PATH
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export ANDROID_HOME=/home/luca-linux/Desktop/android-sdk-linux/
export LC_ALL=en_US.UTF-8
#export GOPATH=/usr/local/go
export GOPATH=$HOME/.local/go
#export GOROOT=/usr/bin/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$HOME/.local/bin:$PATH

alias ssh='assh wrapper ssh'

[ -f $HOME/.zsh-history-substring-search.zsh ] && source $HOME/.zsh-history-substring-search.zsh

SAVEHIST=100000

# include custom files
if [ -f $HOME/.localrc ]; then
    source $HOME/.localrc
fi
# Launch only if not running
#if [ ! $(ps -ef | grep "syndaemon" | grep -v grep | awk '{ print $2}') ]; then syndaemon -i 0.5 -K -R -d 2> /dev/null ; fi
#source <(kubectl completion zsh)
