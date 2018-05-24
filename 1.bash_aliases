alias emc="emacs -nw"
alias py3="python3"
alias postgre="sudo -u postgres -i"
alias l1="ls -1"

alias slicercli_update='touch ~/.slicerconfig; docker pull docker-registry:5000/slicercli:latest'
alias slicercli_run='docker run --rm -i -t -v $HOME:/root  -v $HOME:/project docker-registry:5000/slicercli /usr/local/bin/slicercli -i'
