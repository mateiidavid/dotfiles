# du -a -BG 2>/dev/null | sort -n -r | head
function find_largest_size --description 'Finds largest size directory recursing down from current path'
    set -l lines $argv[1]
    du -a -BG 2>/dev/null | sort -n -r | head -n $lines
end

