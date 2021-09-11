alias gitmod="nano ~/.gitconfig";
alias gitmodaliases="nano ~/.dotfiles/.bash_aliases && bash"
alias nd="netlify dev"
alias c="clear"

alias resyncdots="source ~/.dotfiles/.bashrc && setup_dotfiles"

alias gitusers="list_git_users"
alias githosts="list_git_hosts"
alias gituser="git config --get user.name && git config --get user.email"
alias gitsetuser="select_git_user"
alias gitadduser="add_git_user"
alias gitaddhost="add_git_host"
alias gitdeluser="delete_git_user"
alias gitdelhost="delete_git_host"




alias gitssh="echo 'SSH Config:'; cat ~/.ssh/config"
alias gitsshmod="echo 'Edit SSH Config'; nano ~/.ssh/config"
alias publickey="get_public_key"


alias clone="git clone"
alias gaa="git add ."
alias gcm="git commit -m"
alias gcmall="gaa && gcm"
alias gp="git push"
alias gl="git log"
alias gco="git checkout"
alias gs="git status"
alias gpsu="git push --set-upstream origin $(__git_ps1 "%s")"
#alias for git undo last commit

alias amateur="cd ~/Personal/Amateur"

alias pdh="cd ~/pdh"
alias pdhapi="cd ~/pdh/downloads-api"
alias pdhapp="cd ~/pdh/downloads-app"
