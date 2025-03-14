#!/bin/zsh

slugify() {
  echo $1 | iconv -t ascii//TRANSLIT | sed -E 's/[~\^]+//g' | sed -E 's/[^a-zA-Z0-9]+/-/g' | sed -E 's/^-+\|-+$//g' | sed -E 's/^-+//g' | sed -E 's/-+$//g' | tr A-Z a-z
}

create_pr() {
  USER_NAME="gferrate"
  PR_NAME="$1"
  JIRA_ID="$2"

  if [ -z "${PR_NAME}" ]; then
    echo "PR Comment missing"
    # Restore previous options before returning
    return 1
  fi

  # Format the PR title with JIRA ID if provided
  if [ -n "${JIRA_ID}" ]; then
    PR_TITLE="[${JIRA_ID}] ${PR_NAME}"
  else
    PR_TITLE="${PR_NAME}"
  fi

  SLUGGED_PR=$(slugify $PR_NAME)
  BRANCH_NAME="$USER_NAME/$SLUGGED_PR"

  MASTER=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  if [ -z "${MASTER}" ]; then
    echo "Master branch not found"
    # Restore previous options before returning
    return 1
  fi
  git stash
  gco $MASTER
  gcb $BRANCH_NAME
  git stash pop
  gaa
  gcam "$PR_TITLE"
  gh pr create -t "$PR_TITLE"
  PR_URL=$(gh pr view --json url -q .url)
  if [ -z "${PR_URL}" ]; then
    echo "PR URL not found"
    # Restore previous options before returning
    return 1
  fi
  echo $PR_URL
  TO_COPY=":pr: [$PR_TITLE]($PR_URL)"

  if command -v pbcopy >/dev/null 2>&1; then
    echo $TO_COPY | pbcopy # Copy to clipboard
    echo "PR link copied to clipboard with Slack formatting"
  else
    echo "pbcopy not available. PR link: $TO_COPY"
    echo "PR link not copied to clipboard - pbcopy command not found"
  fi

  # Restore previous options before exiting function
}

# Alias
alias ss="source ~/.zshrc"
alias vi="nvim"
alias vim="nvim"

# Exports
export PATH=/opt/homebrew/bin:$PATH

# Oh my zsh config
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git autojump)
source $ZSH/oh-my-zsh.sh
