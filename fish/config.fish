# Greetings my good sir
function fish_greeting
   printf '\n\n'
   fortune 
end

# Aliases
alias gst='git status'
alias k='kubectl'
alias kgp='kubectl get pods'
alias tmx='tmux attach || tmux new'
alias ls='exa --icons'
alias la='exa -la --icons --colour-scale'
alias ll='exa -abghHli --icons'

# Ripgrep&FZF
# RTFM man fzf
set -x FZF_DEFAULT_COMMAND "rg --files --hidden"

# My Fishy conf
# Starship prompt
starship init fish | source
