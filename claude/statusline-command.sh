#!/bin/bash

# Read JSON input
input=$(cat)

# Extract current directory
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Username
username=$(whoami)

# Get shortened directory (fish-style with length 1)
get_short_dir() {
    local dir="$1"
    if [ "$dir" = "$HOME" ]; then
        echo "~"
        return
    fi
    dir="${dir/#$HOME/~}"

    # Split path and shorten all but last component
    IFS='/' read -ra parts <<< "$dir"
    local result=""
    local len=${#parts[@]}

    for ((i=0; i<len-1; i++)); do
        local part="${parts[i]}"
        if [ -n "$part" ]; then
            result+="${part:0:1}/"
        elif [ $i -eq 0 ]; then
            result+="/"
        fi
    done
    result+="${parts[len-1]}"
    echo "$result"
}

short_dir=$(get_short_dir "$cwd")

# Git information (skip optional locks for performance)
git_info=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    # Get branch name
    branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)

    if [ -n "$branch" ]; then
        git_info=$(printf '\033[90m%s\033[0m' " $branch")

        # Check git status
        if ! git -C "$cwd" --no-optional-locks diff-index --quiet HEAD -- 2>/dev/null; then
            git_info+=$(printf '\033[38;5;218m*\033[0m')
        fi

        # Check for untracked files
        if [ -n "$(git -C "$cwd" --no-optional-locks ls-files --others --exclude-standard 2>/dev/null)" ]; then
            git_info+=$(printf '\033[38;5;218m\033[0m')
        fi

        # Check ahead/behind
        upstream=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref @{upstream} 2>/dev/null)
        if [ -n "$upstream" ]; then
            ahead=$(git -C "$cwd" --no-optional-locks rev-list --count @{upstream}..HEAD 2>/dev/null)
            behind=$(git -C "$cwd" --no-optional-locks rev-list --count HEAD..@{upstream} 2>/dev/null)

            if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
                git_info+=$(printf ' \033[36m⇕⇡%s⇣%s\033[0m' "$ahead" "$behind")
            elif [ "$ahead" -gt 0 ]; then
                git_info+=$(printf ' \033[36m⇡%s\033[0m' "$ahead")
            elif [ "$behind" -gt 0 ]; then
                git_info+=$(printf ' \033[36m⇣%s\033[0m' "$behind")
            fi
        fi

        git_info+=" "
    fi
fi

# Build the status line
printf '\033[1;38;5;203m%s \033[0m' "$username"
printf '\033[34m%s\033[0m' "$short_dir"
printf '%s' "$git_info"
