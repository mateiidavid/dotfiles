#++++++++++++++++#
##   MANOPT     ##
#+++++++++++++++#
#
# Wrapper script that uses man and awk to search for CLI args to popular UNIX
# tools (or tools that would otherwise have a man page)
#
# SYNOPSIS
#   manopt command opt
#
# DESCRIPTION
#   Returns the portion of COMMAND's man page describing option OPT.
#   Note: Result is plain text - formatting is lost.
#
#   OPT may be a short option (e.g., -F) or long option (e.g., --fixed-strings);
#   specifying the preceding '-' or '--' is OPTIONAL - UNLESS with long option
#   names preceded only by *1* '-', such as the actions for the `find` command.
#
#   Matching is exact by default; to turn on prefix matching for long options,
#   quote the prefix and append '.*', e.g.: `manopt find '-exec.*'` finds
#   both '-exec' and 'execdir'.
#
# EXAMPLES
#   manopt ls l           # same as: manopt ls -l
#   manopt sort reverse   # same as: manopt sort --reverse
#   manopt find -print    # MUST prefix with '-' here.
#   manopt find '-exec.*' # find options *starting* with '-exec'
function manopt()
  # Get fn args in local vars
  set -l cmd $argv[1]
  # Arg we want to look up in man page
  set -l opt $argv[2]
  # No arg? No -? then stahp
  if not echo $opt | grep '^-' >/dev/null
    if [ (string length $opt) = 1 ]
      set opt "-$opt"
    else
      set opt "--$opt"
    end
  end
  man "$cmd" | col -b | awk -v opt="$opt" -v RS = '$0 ~ "(^|,)[[:blank:]]+" opt "([[:punct:][:space:]]|$)"'
end

# Credits:
# 
# https://stackoverflow.com/questions/19198721/is-there-a-way-to-look-for-a-flag-in-a-man-page/19199172#19199172

  
