# Automate git merges/pushes to master and staging branch
function alameda_push() {
  local branch=$(git branch --show-current 2> /dev/null)
  local flag=$1

  if [[ $branch =~ ^(master|staging)$ ]]; then
    echo 'Already on master or staging branch'
  else
    if [[ $flag == '-a' ]]; then
      gpush && gcom && gm $branch --no-edit && gpush && gcos && gm $branch --no-edit && gpush && gco $branch
    elif [[ $flag == '-m' ]]; then
      gpush && gcom && gm $branch --no-edit && gpush && gco $branch
    elif [[ $flag == '-s' ]]; then
      gpush && gcos && gm $branch --no-edit && gpush && gco $branch
    elif [[ $flag == '-h' ]]; then
      echo 'Usage:'
      echo '-a: Push/Merge to master and staging'
      echo '-m: Push/Merge to master only'
      echo '-s: Push/Merge to staging only'
      echo '-h: Show help information'
    else
      echo 'Invalid flag provided'
    fi
  fi
}

function alameda_path() {
  cd $HOME/mcisemi/alameda/www.mcisemi.com
  git checkout master
  git pull
  cd $1
  git checkout $1 2> /dev/null
  git pull

  local url=$(basename $(pwd))
  code .
  open -a $BROWSER "http://mcisemi.alameda.test/$url"
}

batdiff() {
  git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

delete_cron_job() {
  kubectl -n mci-cronies-prod delete cronjob $1
}

cover_letter() {
  cd $HOME/Documents/resume
  sed "s/\[Company Name\]/$1/g" Cover_letter_template.txt > "$1_Cover_Letter.txt" | cat | pbcopy
  cat "$1_Cover_Letter.txt"
}

diffmci() {
  difft /Users/danieltolan/mcisemi/group-portal/web/$1 /Users/danieltolan/mcisemi/group-portal2/web/$2
}
