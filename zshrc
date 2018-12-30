# File: .zshrc  ZSH resource file  # {{{1
# vim:fdm=marker ts=4
# 参考: {{{2
# https://github.com/lilydjwg/dotzsh
# https://github.com/MrElendig/dotfiles-alice
# https://github.com/robbyrussell/oh-my-zsh
# https://github.com/solnic/dotfiles/tree/master/home/zsh

# 变量与选项 #{{{1
# 历史记录{{{2
# 不保存重复的历史记录项
setopt hist_save_no_dups
setopt hist_ignore_dups
# setopt hist_ignore_all_dups
# 在命令前添加空格，不将此命令添加到记录文件中
setopt hist_ignore_space

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# 选项和环境变量 {{{2
# 设置 url-quote-magic {{{3
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
#}}}
# rm * 时不要提示
setopt rm_star_silent

setopt autocd

export TERM="xterm-256color" 
export EDITOR="vim"
export SYSTEMD_EDITOR="vim"
export LANG="en_US.utf8"

export ANDROID_NDK_HOME=/usr/local/android-ndk-r14b
export STAGING_DIR=/usr/local/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$STAGING_DIR/bin:$HOME/go/bin
#export PATH=$PATH:/usr/local/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/bin:/usr/local/rsdk-1.5.5-5281-EB-2.6.30-0.9.30.3-110714/bin
export LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';

# 补全与 zstyle {{{1
# 不要报告 no matches 错误，直接使用原来的内容
setopt no_nomatch
# 用本用户的所有进程补全
autoload -Uz compinit
compinit
zstyle :compinstall filename '${HOME}/.zshrc'
zstyle '*' single-ignored show
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#刷新自动补全
#zstyle ':completion:*' rehash true

# 进程名补全
# Process completion shows all processes with colors
#zstyle ':completion:*:*:*:*:processes' menu yes select
#zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' command 'ps -A -o pid,user,cmd'
zstyle ':completion:*:*:*:*:processes' list-colors "=(#b) #([0-9]#)*=0=${color[green]}"
#zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -e -o pid,user,tty,cmd'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -u ${USER} -o pid,tty,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:processes-names' command  'ps c -u ${USER} -o command | uniq'

# 警告显示为红色
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
# 描述显示为淡色
#zstyle ':completion:*:descriptions' format $'\e[2m -- %d --\e[0m'
#zstyle ':completion:*:corrections' format $'\e[01;33m -- %d (errors: %e) --\e[0m'
# cd 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
# 在 .. 后不要回到当前目录
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# complete manual by their section, from grml
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*' menu select
# 分组显示
zstyle ':completion:*' group-name ''
# 歧义字符加粗（使用「true」来加下划线）；会导致原本的高亮失效
# http://www.thregr.org/~wavexx/rnd/20141010-zsh_show_ambiguity/
# zstyle ':completion:*' show-ambiguity '1;37'
# 在最后尝试使用文件名
zstyle ':completion:*' completer _complete _match _approximate _expand_alias _ignored _files
# 修正大小写
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle -e ':completion:*' special-dirs \
  '[[ $PREFIX == (../)#(|.|..) ]] && reply=(..)'
# Don't complete uninteresting users {{{2
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
    clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
    gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
    ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
    named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
    operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
    rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
    usbmux uucp vcsa wwwrun xfs '_*'
# }}}
# 使用缓存。某些命令的补全很耗时的（如 aptitude）{{{2
zstyle ':completion:*' use-cache on
_cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
zstyle ':completion:*' cache-path $_cache_dir
unset _cache_dir
# }}}

# 键映射  Keybindings# {{{1
# 设置为vi mode
bindkey -v
# 设置 ^I 为使用vi编辑 {{{2
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd '^I' edit-command-line

# ^P ^N 分别为上一条、下一条命令 {{{2
#bindkey '^P' up-history
#bindkey '^N' down-history
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey '^R' history-incremental-search-backward

# 设置 vi 命令模式下 K 为使用 sudo 执行. {{{2
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
# 别名 Alias  # {{{1
# 常用 {{{2
alias _="sudo"
alias vi="vim"
alias ls="ls --color"
alias ll="ls --color -lh"
alias grep="grep --color"

#alias for cnpm
alias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"
# 目录相关 {{{2
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus
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
# }}}
# 路径别名 {{{2
hash -d music="$HOME/Desktop/music"
hash -d ebook="$HOME/Desktop/ebook"
hash -d image="$HOME/Desktop/image"
# 类型相关 {{{2
alias -s {pdf,ps,djvu}="evince"
alias -s mp3="mplayer -really-quiet -nolirc"
#alias -s mp3="mplayer -really-quiet -nolirc -loop 0"
# 命令提示符 prompt# {{{1
[[ -n $ZSH_PS_HOST && $ZSH_PS_HOST != \(*\)\  ]] && ZSH_PS_HOST="($ZSH_PS_HOST) "
autoload -U colors && colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{$fg[yellow]%}[%b]%{$fg[grey]%}%m %{$fg[red]%}%u %{$fg[green]%}%c%{$reset_color%}"
precmd () { vcs_info }

## 为方便复制，右边的提示符只在最新的提示符上显示
setopt transient_rprompt
# 允许提示符替换。
setopt PROMPT_SUBST

PROMPT="[%{$fg_bold[magenta]%}%n%{$reset_color%}@%{$fg_bold[red]%}%m%{$reset_color%}:%{$fg_bold[blue]%}%~% %{$reset_color%}]%(?.%{$fg[green]%}.%{$fg[red]%})%B%#%b %{$reset_color%}"
# 右边的提示
RPROMPT='$ZSH_PS_HOST ${vcs_info_msg_0_} %{$reset_color%}[%T]'

man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[01;31m") \
		LESS_TERMCAP_md=$(printf "\e[01;38;5;74m")\
		LESS_TERMCAP_me=$(printf "\e[0m")\
		LESS_TERMCAP_se=$(printf "\e[0m")\
		LESS_TERMCAP_so=$(printf "\e[7m")\
		LESS_TERMCAP_ue=$(printf "\e[0m")\
		LESS_TERMCAP_us=$(printf "\e[04;38;5;146m:")\
		man "$@"
}

# 其它 {{{1
weather () { #天气预报 {{{2
	#curl http://wttr.in/$1 2>/dev/null | head -n 7
	local city
	if [[ $# -eq 1 ]]; then
		city="&city=$1"
	fi
	w3m -dump "http://weather1.sina.cn/?vt=1$city" 2>/dev/null | sed '1,/注册/d;/分享/,$d;s/\[[^]]\+\]//g;' | sed -n '/^$/!H;/^$/{x;s/\n/\t/g;s/ /\t/g;s/^\t//;p}'
	#w3m -dump "http://weather1.sina.cn/?vt=1$city" 2>/dev/null | sed '1,/注册/d;/分享/,$d;s/\[[^]]\+\]//g;/^\s*$/d'
}
lookip (){ # ip归属地 {{{2
	curl ip.cn/$1 2>/dev/null
}

