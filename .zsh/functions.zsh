# Git branch in prompt.
function parse_git_branch() {
	git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/(\1)/p'
}

# Automate git merges/pushes to master and staging branch
function alameda_push() {
  local branch=$(git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
  local flag=$1

  if [[ $branch == 'master' || $branch == 'staging' ]];then
    echo 'Already on master or staging branch'
  else
    if [[ $flag == '-a' ]]; then
      gpush && gcom && gm $branch && gpush && gcos && gm $branch && gpush && gco $branch
    elif [[ $flag == '-m' ]]; then
      gpush && gcom && gm $branch && gpush && gco $branch
    elif [[ $flag == '-s' ]]; then
      gpush && gcos && gm $branch && gpush && gco $branch
    elif [[ $flag == '-h' ]]; then
      echo 'Usage:'
      echo '-a: Merge/Push to master and staging'
      echo '-m: Merge/Push to master only'
      echo '-s: Merge/Push to staging only'
      echo '-h: Show help information'
    else
      echo 'Invalid flag provided'
    fi
  fi
}

function alameda_path() {
  cd $HOME/mcisemi/alameda/www.mcisemi.com/$1
  gco $1 2> /dev/null
  gpull

  local url=$(basename $(pwd))
  code .
  open -a $BROWSER "http://mcisemi.alameda.test/$url"
}
