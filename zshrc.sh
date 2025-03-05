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
  git stash
  gco $MASTER
  gcb $BRANCH_NAME
  git stash pop
  gaa
  gcam $PR_NAME
  gh pr create -t $PR_NAME --draft
  PR_URL=$(gh pr view --json url -q .url)
  echo $PR_URL
  TO_COPY=":pr: [$PR_NAME]($PR_URL)"
  echo $TO_COPY | pbcopy
  echo "PR link copied to clipboard with Slack formatting"
}
