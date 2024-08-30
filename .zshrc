
alias gst='git status'

alias ls='exa --icons'
alias la='exa -la --icons --colour-scale'
alias ll='exa -abghHli --icons'

# Ripgrep&FZF
# RTFM man fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden"

eval "$(starship init zsh)"
