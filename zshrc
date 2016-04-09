#----------------------------------------------------------------#
# File:		.zshrc  	ZSH resource file  						 #
#----------------------------------------------------------------#

#------------------------------
# Variables
#------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
export EDITOR="vim"
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';

#------------------------------
# Keybindings
#------------------------------
autoload -U edit-command-line
bindkey -v
zle -N edit-command-line
bindkey -M vicmd '^I' edit-command-line
bindkey '^P' up-history
bindkey '^N' down-history

vi-append-x-clipboard() { LBUFFER="$LBUFFER $(xclip -o -selection clipboard)"; }
zle -N vi-append-x-clipboard
bindkey '^V' vi-append-x-clipboard
#bindkey -a '^V' vi-append-x-clipboard
# vi-yank-x-clipboard() { print -rn -- $CUTBUFFER | xclip -i -selection clipboard; }
#zle -N vi-yank-x-clipboard
#bindkey -a '^X' vi-yank-x-clipboard

sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey -a "K" sudo-command-line

#------------------------------
# Alias stuff
#------------------------------
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
alias ...="../.."
alias ....="../../.."
alias .....="../../../.."
alias ......="../../../../.."
alias 1="cd -"
alias 2="cd -2"
alias 3="cd -3"
alias 4="cd -4"
alias 5="cd -5"
alias 6="cd -6"
alias 7="cd -7"
alias 8="cd -8"
alias 9="cd -9"
alias d="dirs -v | head -10"
alias _="sudo"
alias ls="ls --color"
alias ll="ls --color -lh"
alias grep="grep --color"

#------------------------------
# ShellFuncs
#------------------------------
# -- coloured manuals
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		man "$@"
}

#------------------------------
# Comp stuff
#------------------------------
autoload -Uz compinit
compinit
zstyle :compinstall filename '${HOME}/.zshrc'
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:*:*:*' menu select
zstyle '*' single-ignored show
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'		force-list always
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'	 force-list always

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# -----------------------------------------------
# Set up the prompt
# -----------------------------------------------
autoload -U colors zsh/terminfo
colors
PROMPT="[%{$fg_bold[magenta]%}%n%{$reset_color%}@%{$fg_bold[red]%}%m%{$reset_color%}:%{$fg_bold[blue]%}%~% %{$reset_color%}]%(?.%{$fg[green]%}.%{$fg[red]%})%B%#%b %{$reset_color%}"
RPROMPT="[%T]"

