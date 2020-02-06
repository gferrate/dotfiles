#export PS1="\[\033[38;5;1m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput sgr0)\]\[\033[38;5;4m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] @ \[$(tput sgr0)\]\[\033[38;5;46m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\\[\033[32m\]\$(parse_git_branch)\[\033[00m\] \n$ \[$(tput sgr0)\]"
export PS1="🍻 \[\033[38;5;6m\][\w]\[\033[33m\]\$(parse_git_branch)$\[\033[00m\]\[$(tput sgr0)\]\[\033[38;5;15m\]\[$(tput sgr0)\] "
#pyjoke -c all
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export BASH_SILENCE_DEPRECATION_WARNING=1
export WORKON_HOME=~/.virtualenvs
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
mkdir -p $WORKON_HOME
source /usr/local/bin/virtualenvwrapper.sh
#export PATH=/usr/local/Cellar/python/3.6.5_1/bin/python3.6:$PATH
export PATH=~/.local/bin:$PATH

## Autocomplete for git checkout 
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

HISTFILESIZE=1000000000
HISTSIZE=1000000

parse_git_branch() {
  git branch 2> /dev/null | sed -e ' /^[^*]/d' -e 's/* \(.*\)/  (\1)/'
}


###### Autocompleting ssh hosts ###############################################
function __completeSSHHosts {
	COMPREPLY=()
	local currentWord=${COMP_WORDS[COMP_CWORD]}
	local completeHosts=$(
		cat "$HOME/.ssh/config" | \
			grep --extended-regexp "^Host +([^* ]+ +)*[^* ]+ *$" | \
			tr -s " " | \
			sed -E "s/^Host +//"
	)

	COMPREPLY=($(compgen -W "$completeHosts" -- "$currentWord"))
	return 0
}

complete -F __completeSSHHosts ssh
#complete -F __completeSSHHosts scp
############################################################################### 
alias tailf='tail -f'
alias pyc='find . -name "*.pyc" -exec rm -f {} \;'
#alias ipython='ipython --TerminalInteractiveShell.editing_mode=vi'
alias preview="fzf --preview 'bat --color \"always\" {}'"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export PROJECT_HOME=~/projects/

export CLICOLOR=5
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'
alias glog='git log --graph'
# Created by `userpath` on 2019-06-05 13:15:34
export PATH="$PATH:/Users/gferrate/.local/bin"
