alias sudo="sudo "
alias emc="emacs -nw"
alias py3="python3"
alias postgre="sudo -u postgres -i"
alias grep="grep --color"
alias tmx="tmux new-session -n ''"
alias historyreset="history -c; history -r"

alias slicercli_update='touch ~/.slicerconfig; docker pull docker-registry:5000/slicercli:latest'
alias slicercli_run='docker run --rm -i -t -v $HOME:/root  -v $HOME:/project docker-registry:5000/slicercli /usr/local/bin/slicercli -i'

pylintdiff() {
    if [ "$#" -ne 0 ]
    then
        branch="$1"
    else
        branch="master"
    fi

    git diff $branch --name-only | grep -e '.py$' | xargs pylint -r no
}

HISTCONTROL=ignoreboth:erasedups
HISTSIZE=3000
HISTFILESIZE=3000

# Update bash_history after every command. It's useful when you use
# tmux. Because you don't have to close every window manually in order
# to update bash_history with window's history list.
# I'm not sure that the command "shopt -s histappend" is really
# necessary. It seems that everything works well without it.
#shopt -s histappend
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

bind '"\C-f": forward-search-history'

if [[ $HOSTNAME == MacBook-Pro-Aleksey* ]] || [[ $HOSTNAME == MBP-Aleksey* ]]
then
    alias ls="ls -G"
    alias ll="ls -l"
    alias la="ls -a"

    PS1='\[\033[01;32m\]\u@Mac\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    export LSCOLORS=exaccxdxGxegedabagehex
    cp /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash /usr/local/etc/bash_completion.d/
    source /usr/local/etc/bash_completion.d/git-completion.bash
    export BASH_SILENCE_DEPRECATION_WARNING=1
else
    LS_COLORS="di=34:ln=30;42:so=32:pi=33:ex=1;36:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=34;47:ow=34"
    alias ls="ls --color"
fi