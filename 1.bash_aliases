alias sudo="sudo "
alias emc="emacs -nw"
alias py3="python3"
alias postgre="sudo -u postgres -i"
alias ls="ls -G"
alias ll="ls -l"
alias la="ls -a"
alias grep="grep --color"

alias slicercli_update='touch ~/.slicerconfig; docker pull docker-registry:5000/slicercli:latest'
alias slicercli_run='docker run --rm -i -t -v $HOME:/root  -v $HOME:/project docker-registry:5000/slicercli /usr/local/bin/slicercli -i'

pylintdiff() {
    if [ "$#" -ne 0 ]
    then
        branch="$1"
    else
        branch="origin/master"
    fi

    git diff $branch --name-only | grep -e '.py$' | xargs pylint -r no
}

# Preserve bash_history across multiple tmux sessions # # #
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1000
HISTFILESIZE=1000
shopt -s histappend

PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
# # #

bind '"\C-f": forward-search-history'

if [[ $HOSTNAME == MacBook-Pro-Aleksey* ]] || [[ $HOSTNAME == MBP-Aleksey* ]]
then
    PS1='\[\033[01;32m\]\u@Mac\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    export LSCOLORS=exaccxdxGxegedabagehex
    cp /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash /usr/local/etc/bash_completion.d/
    source /usr/local/etc/bash_completion.d/git-completion.bash
fi
