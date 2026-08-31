if status is-interactive
    # Commands to run in interactive sessions can go here
    ~/.local/bin/mise activate fish | source

    alias fe="code ~/.config/fish"
    alias fu="source ~/.config/fish/config.fish"

    #oxidize
    alias cd="z"
    alias ls="eza -lah"
    if command -q bat
        alias cat="bat"
    else if command -q batcat
        alias cat="batcat"
    end
    alias grep="rg"

    # Invoke a local script for environment variables and platform-specific aliases.
    # local.fish is intentionally not tracked, so only load it when it exists.
    if test -f ~/.config/fish/local.fish
        source ~/.config/fish/local.fish
    end


    function fish_greeting
    end
end

zoxide init fish | source
