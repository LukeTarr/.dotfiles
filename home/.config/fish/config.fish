if status is-interactive
    # Commands to run in interactive sessions can go here
    ~/.local/bin/mise activate fish | source

    alias fe="code ~/.config/fish"
    alias fu="source ~/.config/fish/config.fish"

    #oxidize
    alias cd="z"
    alias ls="eza -lah"
    alias cat="bat"
    alias grep="rg"

    #invoke local script to set up env vars, and platform specific aliases
    source ~/.config/fish/local.fish


    function fish_greeting
    end
end

zoxide init fish | source
