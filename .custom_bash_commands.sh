function branch() {
  git checkout -B $1 origin/main
}
function debranch() {
  git stash save -m unstaged $1
  git checkout main
  git branch -D $1
  git pull
}
## glg $1 | git log --grep=$1
function glg() {
  git log --grep='$1'
}

## gls $1 | find logs that changed a specific string
function gls() {
  git log -S $1
}
## glc $1 $2 | git log between 2 commits
function glc() {
  git log $1..$2
}
## gln $1 |git log -n
function gln() {
  git log -n $1
}
## glno $1 | git log -n $1 --oneline
function glno() {
  git log -n $1 --oneline
}
## stashl | git stash list
function stashl() {
  git stash list
}
## stashs | git stash save
function stashs() {
  git stash save
}
## stashm $1 | git stash save -m $1
function stashm() {
  git stash save -m $1
}
## stasha $ | git stash apply $1
function stasha() {
  git stash apply $1
}
## reboot | espanso, tailscale will prompt for password, ktd_proxy
function reboot() {
  er
  sudo -S systemctl start tailscaled
  tailscale up
  ktd_proxy --start
  ktd_proxy --status
}
## kp  $1 | ktd --name $1 --proxy up -d, wait-ready, echo url, enter shell local run.sh file
function kp() {
  ktd --name $1 --proxy --localrun $2 up -d
  ktd --name $1 --shell --wait-ready 120
  echo "\thttp://$1-intra.localhost"
  sleep 2
  ktd --name $1 --shell
}
## kpp $1 | ktd --name $1 --plugins --proxy up -d, wait-ready, echo url, enter shell local run.sh file
function kpp() {
  ktd --name $1 --plugins --proxy --localrun up -d
  ktd --name $1 --shell --wait-ready 120
  echo "\thttp://$1-intra.localhost"
  sleep 2
  ktd --name $1 --shell
}
## kpe $1 | ktd --name $1 --proxy up --search-engine es7 -d wait-ready echo url, enter shell, local run.sh file
function kpe() {
  ktd --name $1 --proxy --localrun --search-engine es7 up -d
  ktd --name $1 --wait-ready 120
  echo "\thttp://$1-intra.localhost"
  ktd --name $1 --shell
}

## kppe $1 | ktd --name $1 --proxy up --plugins --search-engine es7 -d wait-ready echo url, enter shell, local run.sh file
function kppe() {
  ktd --name $1 --proxy --localrun --plugins --search-engine es7 up -d
  ktd --name $1 --wait-ready 120
  echo "\thttp://$1-intra.localhost"
  ktd --name $1 --shell
}

## kpd $1 | ktd --name $1 down
function kpd() {
  ktd --name $1 down
}

## functions | list functions
function functions() {
  awk '/##/' /home/lisette/.custom_bash_commands.sh | awk 'BEGIN {FS = "## "} ; {print $2}' | awk 'BEGIN {FS = "|"} ; {print "\033[32m" $1 "\033[37m" $2}'

}
##
## readfunction | more detail on a specific function
readfunction() {
  echo
  grep -i "##" /home/lisette/.custom_bash_commands.sh
  echo
  echo -n "enter function name: "
  read -e name
  echo
  clear
  sed -n "/${name}/,/##/p" /home/lisette/.custom_bash_commands.sh
}

## -WORKTREES-
##
## wtbug $1 | start a new worktree with the name $1
function wtnew() {
  cd ~/git/koha
  git fetch origin main
  git worktree add -b bug_$1 ~/git/koha-worktrees/bug_$1 origin/main
  echo "$GREEN\t✔ worktree bug_$1 completed"
  ln -s ~/git/koha/shared ~/git/koha-worktrees/bug_$1/shared
  echo -e "\t✔ shared symlink created"
  SYNC_REPO=~/git/koha-worktrees/bug_$1 ktd --proxy --localrun --name bug$1 up -d
  ktd --name bug$1 --shell --wait-ready 120
  echo -e "\t http://bug$1-intra.localhost"
  sleep 2
  ktd --name bug$1 --shell
}

function wtup() {
  cd ~/git/koha-worktrees/bug_$1
  SYNC_REPO=~/git/koha-worktrees/bug_$1 ktd --proxy --localrun --name bug$1 up -d
  ktd --name bug$1 --shell --wait-ready 120
  echo -e "\thttp://bug$1-intra.localhost"
  sleep 2
  ktd --name bug$1 --shell
}

function wtclear() {
  ktd down bug$1
  unlink ~/git/koha-worktrees/bug_$1/shared
  git -C ~/git/koha worktree remove ~/git/koha-worktrees/bug_$1
  echo -e "\t$GREEN✔ removed git worktree bug_$1"
}
