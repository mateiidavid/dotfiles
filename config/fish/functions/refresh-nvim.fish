function refresh-nvim --description 'Kills zombie nvim processes'
    set -l s_pids (pidof nvim -d ',')
    set -l pids (string split , $s_pids)
    for pid in $pids
        echo "Reaping $pid"
        kill -s KILL $pid
        echo "Reaped"
    end
end
