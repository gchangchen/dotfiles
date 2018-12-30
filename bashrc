#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
#PS1='[\u@\h \W]\$ '
PS1='[\[\e[35;1m\]\u\[\e[0m\]@\[\e[31;1m\]\h\[\e[0m\]:\[\e[32;1m\]\W\[\e[0m\]]\$'
shopt -s checkwinsize

set -o vi
export VISUAL="vim"
export EDITOR="vim"

