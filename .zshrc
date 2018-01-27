# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Zsh completion
fpath=(/usr/local/share/zsh-completions $fpath)

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it ll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="gentoo"
ZSH_THEME="robbyrussell"
#ZSH_THEME="gianu"
#ZSH_THEME="lukerandall"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

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

# TMUX SHORTCUTS
alias sv='tmux split -v'
alias sh='tmux split -h'
alias s='tmux select-pane -t'
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
export GOPATH=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:$HOME/.cargo/bin

alias ssh='assh wrapper ssh'

# FUZZY FINDER
alias s='fzf'
alias cs='fzf | xargs code'
alias gs='fzf | xargs gedit'
# BREW PATH
PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

[ -f $HOME/.zsh-history-substring-search.zsh ] && source $HOME/.zsh-history-substring-search.zsh

# Launch only if not running
#if [ ! $(ps -ef | grep "syndaemon" | grep -v grep | awk '{ print $2}') ]; then syndaemon -i 0.5 -K -R -d 2> /dev/null ; fi

PATH="/home/luca-linux/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/luca-linux/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/luca-linux/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/luca-linux/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/luca-linux/perl5"; export PERL_MM_OPT;
