function setscheme
    if test -z "$argv"
        return 1
    end

    if test -f $XDG_CONFIG_HOME/fish/themes/$argv[1].fish
        fish $XDG_CONFIG_HOME/fish/themes/$argv[1].fish
    end
end
