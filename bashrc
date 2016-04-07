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

export STAGING_DIR=/usr/local/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2

export PATH=$PATH:/usr/local/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/bin:/usr/local/rsdk-1.5.5-5281-EB-2.6.30-0.9.30.3-110714/bin


export VISUAL="vim"
export EDITOR="vim"

