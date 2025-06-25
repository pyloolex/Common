alias sudo="sudo "
alias emc="emacs -nw"
alias grep="grep --color"
alias tmx="tmux new-session -n ''"
alias agrep="grep --exclude-dir='*test*'"
alias grepa="grep --exclude-dir='*test*'"


if [[ $(hostname) == "MacBook-Pro.local" ]]
then
    # Settings for ZSH #

    alias ls="ls -G"
    alias ll="ls -l"
    alias la="ls -a"
    alias restnotif="pkill notificationcenterui"

    # This is the analogy for `show-all-if-ambiguous` from `bash`.
    # Don't autocomplete command if there are multiple options.
    setopt no_auto_menu
    setopt bash_auto_list

    # Just do this one time: "compaudit | xargs chmod g-w"
    # if you see errors about unsecure files.
    # This is a git autocompletion btw.
    autoload -Uz compinit && compinit

    # GNU grep instead of the default MACOS one.
    PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

    # Android debugging tool.
    PATH="/Users/aslootsky/Library/Android/sdk/platform-tools:$PATH"

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


    PROMPT="%B%F{10}%n%f%b%B%F{10}@%f%b%B%F{10}%m%f%b:%B%F{12}%~%f%b$ "
    export LSCOLORS=DxaccxdxGxegedabagehex

    bindkey -s '^[e' 'ssh sfvirtual\n'
else
    # Bash settings #

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
    LS_COLORS="di=1;33:ln=30;42:so=32:pi=33:ex=1;36:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=34;47:ow=34"

    bind '"\eh": "tmux attach-session -t 0\n"'
    bind '"\ev": "tmux attach-session -t 1\n"'
fi
