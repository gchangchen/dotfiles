# File: .zshrc  ZSH resource file  # {{{1
# vim:fdm=marker ts=4
# 参考: {{{2
# https://github.com/lilydjwg/dotzsh
# https://github.com/MrElendig/dotfiles-alice
# https://github.com/robbyrussell/oh-my-zsh

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
# rm * 时不要提示
setopt rm_star_silent

export EDITOR="vim"
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';

# 补全与 zstyle {{{1
# 用本用户的所有进程补全
autoload -Uz compinit
compinit
zstyle :compinstall filename '${HOME}/.zshrc'
zstyle '*' single-ignored show
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# 进程名补全
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
bindkey '^P' up-history
bindkey '^N' down-history

# 设置 ^V 为粘贴，需要安装xclip。{{{2
vi-append-x-clipboard() { LBUFFER="$LBUFFER $(xclip -o -selection clipboard)"; }
zle -N vi-append-x-clipboard
bindkey '^V' vi-append-x-clipboard

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
# 自动记住已访问目录栈
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
alias _="sudo"
alias ls="ls --color"
alias ll="ls --color -lh"
alias grep="grep --color"
# 命令提示符 prompt# {{{1
# git 分支显示 {{{2

if (( $+commands[git] )); then
  _nogit_dir=()
  for p in $nogit_dir; do
    [[ -d $p ]] && _nogit_dir+=$(realpath $p)
  done
  unset p

  _etup_current_branch_async () { # {{{3
    typeset -g _current_branch= vcs_info_fd=
    zmodload zsh/zselect 2>/dev/null

    _vcs_update_info () {
      eval $(read -rE -u$1)
      zle -F $1 && vcs_info_fd=
      exec {1}>&-
      # update prompt only when necessary to avoid double first line
      [[ -n $_current_branch ]] && zle reset-prompt
    }

    _set_current_branch () {
      _current_branch=
      [[ -n $vcs_info_fd ]] && zle -F $vcs_info_fd
      cwd=$(pwd -P)
      for p in $_nogit_dir; do
        if [[ $cwd == $p* ]]; then
          return
        fi
      done

      setopt localoptions no_monitor
      coproc {
        _br=$(git branch --no-color 2>/dev/null)
        if [[ $? -eq 0 ]]; then
          _current_branch=$(echo $_br|awk '$1 == "*" {print "%{\x1b[33m%} (" substr($0, 3) ")"}')
        fi
        # always gives something for reading, or _vcs_update_info won't be
        # called, fd not closed
        #
        # "typeset -p" won't add "-g", so reprinting prompt (e.g. after status
        # of a bg job is printed) would miss it
        #
        # need to substitute single ' with double ''
        print "typeset -g _current_branch='${_current_branch//''''/''}'"
      }
      disown %{\ _br
      exec {vcs_info_fd}<&p
      # wait 0.1 seconds before showing up to avoid unnecessary double update
      # precmd functions are called *after* prompt is expanded, and we can't call
      # zle reset-prompt outside zle, so turn to zselect
      zselect -r -t 10 $vcs_info_fd 2>/dev/null
      zle -F $vcs_info_fd _vcs_update_info
    }
  }

  _setup_current_branch_sync () { # {{{3
    _set_current_branch () {
      _current_branch=
      cwd=$(pwd -P)
      for p in $_nogit_dir; do
        if [[ $cwd == $p* ]]; then
          return
        fi
      done

      _br=$(git branch --no-color 2>/dev/null)
      if [[ $? -eq 0 ]]; then
        _current_branch=$(echo $_br|awk '{if($1 == "*"){print "%{\x1b[33m%} (" substr($0, 3) ")"}}')
      fi
    }
  } # }}}

  if [[ $_has_re -ne 1 ||
    $ZSH_VERSION =~ '^[0-4]\.' || $ZSH_VERSION =~ '^5\.0\.[0-5]' ]]; then
    # zsh 5.0.5 has a CPU 100% bug with zle -F
    _setup_current_branch_sync
  else
    _setup_current_branch_async
  fi
  typeset -gaU precmd_functions
  precmd_functions+=_set_current_branch
fi
# }}}2

[[ -n $ZSH_PS_HOST && $ZSH_PS_HOST != \(*\)\  ]] && ZSH_PS_HOST="($ZSH_PS_HOST) "
autoload -U colors
colors
## 为方便复制，右边的提示符只在最新的提示符上显示
setopt transient_rprompt
# 允许提示符替换。
setopt PROMPT_SUBST

PROMPT="[%{$fg_bold[magenta]%}%n%{$reset_color%}@%{$fg_bold[red]%}%m%{$reset_color%}:%{$fg_bold[blue]%}%~% %{$reset_color%}]%(?.%{$fg[green]%}.%{$fg[red]%})%B%#%b %{$reset_color%}"
# 右边的提示
RPROMPT="$ZSH_PS_HOST \$_current_branch%{$reset_color%}[%T]"

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

