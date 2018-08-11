#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
[ -r /home/sam/.byobu/prompt ] && . /home/sam/.byobu/prompt   #byobu-prompt#

alias suspend='sudo systemctl suspend'
