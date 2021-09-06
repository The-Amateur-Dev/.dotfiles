#!/bin/bash
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

HISTTIMEFORMAT="%F %T: "
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND='history -a; echo -en "\033]0; $("pwd") \a"'

# export PROMPT_COMMAND='echo -en "\033]0; $("pwd") \a"'