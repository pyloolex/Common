alias sudo="sudo "
alias emc="emacs -nw"
alias py3="python3"
alias postgre="sudo -u postgres -i"
alias grep="grep --color"
alias tmx="tmux new-session -n ''"

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

if [[ $(hostname) == "aslootsky-mbp" ]]
then
    alias ls="ls -G"
    alias ll="ls -l"
    alias la="ls -a"
    alias restnotif="pkill notificationcenterui"

    # This is the analogy for `show-all-if-ambiguous` from `bash`.
    # Don't autocomplete command if there are multiple options.
    setopt no_auto_menu
    setopt bash_auto_list

    export LSCOLORS=exaccxdxGxegedabagehex

    # Just do this one time: "compaudit | xargs chmod g-w"
    # if you see errors about unsecure files.
    # This is a git autocompletion btw.
    autoload -Uz compinit && compinit

    # GNU grep instead of the default MACOS one.
    PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

    # --- History begin --- #
        # Append to history after every command.
        setopt inc_append_history
        # Ignore duplication
        setopt hist_ignore_dups
        # Delete old ones if duplicated
        setopt hist_ignore_all_dups

        # Manual reset of the history.
        alias historyreset="fc -R"

        HISTSIZE=10000
        SAVEHIST=10000

        bindkey '^F' history-incremental-search-forward
    # --- History end --- #


    #PS1='\[\033[01;32m\]\u@Mac\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    #cp /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash /usr/local/etc/bash_completion.d/
    #source /usr/local/etc/bash_completion.d/git-completion.bash
    #export BASH_SILENCE_DEPRECATION_WARNING=1

else
    # --- History begin --- #
        alias historyreset="history -c; history -r"

        # Update bash_history after every command. It's useful when you use
        # tmux. Because you don't have to close every window manually in order
        # to update bash_history with window's history list.
        PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

        HISTCONTROL=ignoreboth:erasedups
        HISTSIZE=10000
        HISTFILESIZE=10000

        bind '"\C-f": forward-search-history'
    # --- History end --- #

    alias ls="ls --color"
LS_COLORS="di=34:ln=30;42:so=32:pi=33:ex=1;36:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=34;47:ow=34"
fi