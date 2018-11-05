alias sudo="sudo "
alias emc="emacs -nw"
alias py3="python3"
alias postgre="sudo -u postgres -i"
alias l1="ls -1 --group-directories-first"

alias slicercli_update='touch ~/.slicerconfig; docker pull docker-registry:5000/slicercli:latest'
alias slicercli_run='docker run --rm -i -t -v $HOME:/root  -v $HOME:/project docker-registry:5000/slicercli /usr/local/bin/slicercli -i'

bind '"\C-f": forward-search-history'

pylintdiff() {
    if [ "$#" -ne 0 ]
    then
        branch="$1"
    else
        branch="origin/master"
    fi

    git diff $branch --name-only | grep -e '.py$' | xargs pylint -r no
}
