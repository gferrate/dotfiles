slugify() {
  echo $1 | iconv -t ascii//TRANSLIT | sed -E 's/[~\^]+//g' | sed -E 's/[^a-zA-Z0-9]+/-/g' | sed -E 's/^-+\|-+$//g' | sed -E 's/^-+//g' | sed -E 's/-+$//g' | tr A-Z a-z
}

create_pr() {
  USER_NAME="gferrate"
  PR_NAME="$1"

  if [ -z "${PR_NAME}" ]; then
    echo "PR Comment missing"
    return
  fi

  SLUGGED_PR=$(slugify $PR_NAME)
  BRANCH_NAME="$USER_NAME/$SLUGGED_PR"

  MASTER=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  if [ -z "${MASTER}" ]; then
    echo "Master branch not found"
    return
  fi
  git stash
  gco $MASTER
  gcb $BRANCH_NAME
  git stash pop
  gaa
  gcam $PR_NAME
  gh pr create -t $PR_NAME
  PR_URL=$(gh pr view --json url -q .url)
  if [ -z "${PR_URL}" ]; then
    echo "PR URL not found"
    return
  fi
  echo $PR_URL
  TO_COPY=":pr: [$PR_NAME]($PR_URL)"
  echo $TO_COPY | pbcopy
  echo "PR link copied to clipboard with Slack formatting"
}

alias ss="source ~/.zshrc"
alias vi="nvim"
alias vim="nvim"

# For the autojump plugin
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
