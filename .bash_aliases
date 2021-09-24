alias gitmod="nano ~/.gitconfig";
alias gitmodaliases="nano ~/.dotfiles/.bash_aliases && bash"
alias gitmodusers="nano ~/.savedGitUsers && bash"
alias gitmodhosts="nano ~/.savedGitHosts && bash"
alias nd="netlify dev"
alias c="clear"
alias y="yarn"
alias ys="yarn start"
alias n="npm"
alias no="node"
alias delnodemod="rm -rf ./node_modules"
alias nmkill="npx npkill -f -s size"
alias resyncdots="source ~/.dotfiles/.bashrc && setup_dotfiles"

alias gitusers="list_git_users"
alias githosts="list_git_hosts"
alias gituser="echo 'Git Author: ' && git config --get user.name && echo 'Author Email: ' && git config --get user.email && echo 'Unique Host: ' && githost"
alias githost="git config --get user.uniqueHostName"
alias gitsetuser="select_git_user"
alias gitadduser="add_git_user"
alias gitaddhost="add_git_host"
alias gitdeluser="delete_git_user"
alias gitdelhost="delete_git_host"

alias gitresetlast="git reset --soft HEAD~1"

alias gitssh="echo 'SSH Config:'; cat ~/.ssh/config"
alias gitmodssh="echo 'Edit SSH Config'; nano ~/.ssh/config"
alias publickey="get_public_key"

gbranch() {
echo $(__git_ps1 "%s")
}
alias giturl="git remote -v"
alias gitmodurl="giturl && git remote remove origin && git remote add origin"
alias clone="git clone"
alias gaa="git add ."
alias gcm="git commit -m"
alias gcmall="gaa && gcm"
alias gp="git push"
alias gf="git fetch"
alias gm="git merge"
alias gl="git log"
alias gco="git checkout"
alias gs="git status"
alias gpsu="git push --set-upstream origin"
#alias for git undo last commit

alias amateur="cd ~/Personal/Amateur"

alias pdh="cd ~/pdh"
alias pdhapi="cd ~/pdh/downloads-api"
alias pdhapp="cd ~/pdh/downloads-app"
alias o="code"
