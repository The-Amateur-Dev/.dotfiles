if [ -f ~/.gitUserFunctions ]; then
    \. ~/.gitUserFunctions
    elif [ -f ~/.dotfiles/.gitUserFunctions ]; then
    \. ~/.dotfiles/.gitUserFunctions
fi
if [ -f ~/.bash_aliases ]; then
    \. ~/.bash_aliases
fi

if [[ ! -d ~/.ssh ]] then;
mkdir -p ~/.ssh
fi
### Set SSH Keys on startup
shopt -s extglob
# rm -rf ~/.ssh/agent.env
# eval `ssh-agent -s`
env=~/.ssh/agent.env
ssh-add ~/.ssh/id_!(*.pub)
agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

### Override CD to check case insensitively
shopt -s extglob
cd () {
  builtin cd "$@" 2>/dev/null && return
  local options_to_unset=; local -a matches
  [[ :$BASHOPTS: = *:extglob:* ]] || options_to_unset="$options_to_unset extglob"
  [[ :$BASHOPTS: = *:nocaseglob:* ]] || options_to_unset="$options_to_unset nocaseglob"
  [[ :$BASHOPTS: = *:nullglob:* ]] || options_to_unset="$options_to_unset nullglob"
  shopt -s extglob nocaseglob nullglob
  matches=("${!#}"@()/)
  shopt -u $options_to_unset
  case ${#matches[@]} in
    0) # There is no match, even case-insensitively. Let cd display the error message.
      builtin cd "$@";;
    1)
      matches=("$@" "${matches[0]}")
      unset "matches[$(($#-1))]"
      builtin cd "${matches[@]}";;
    *)
      echo "Ambiguous case-insensitive directory match:" >&2
      printf "%s\n" "${matches[@]}" >&2
      return 3;;
  esac
}

################
## Set Terminal Prompt
################
parse_git_user() {
    git config --get user.email
}
parse_git_username() {
    git config --get user.name
}
# parse_git_branch() {
#   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
# }
# check_is_git() {
#     GIT=git rev-parse --git-dir 2> /dev/null
#   if [ GIT != ".git" ];then
#   echo "BRANCH \e[0;32m($(parse_git_branch))\e[m | USER \e[0;34m($(parse_git_user))\e[m"
#   else
#   ""
#   fi
# }

## Variables don't seem to work with a dynamic promps, branches wont change when change dir, keeping just incase.
# BRANCH=$(check_is_git)
USER='\e[0;33m$(parse_git_user)\e[m'
TIME="\e[0;31m\@\e[m"
DIR="DIR \e[0;35m(\w)\e[m"
# Wrap colours in \[ .... \] otherwise terminal counts as chars and creates overlapping issue. 
PS1='\[\e[0;31m\]\@\[\e[m\] - \[\e[0;33m\]$(parse_git_username) \[\e[0;35m\](\w)\[\e[m\] \[\e[0;32m\]$(__git_ps1 "(%s)")\[\e[m\]'