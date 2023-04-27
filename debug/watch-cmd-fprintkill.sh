#!/bin/sh

# example usage:
# ./watch-cmd-fprintkill.sh sleep sh -c 'sleep 111 & sleep 222 & sleep 333 &'

FPK_EXEC="$2" ; export FPK_EXEC
n=3
while eval "test -n \"\$$n\""; do
    eval "FPK_ARGS=\"$FPK_ARGS '\$$n'\""
    n=$((n+1))
done
export FPK_ARGS
sh -x `dirname $0`/../fprintkill &
watch -n1 "(echo $$ ; pgrep fprintkill ; pgrep fprintd-verify ; pgrep '$1' ) | xargs ps -oppid,pid,pgid,cmd "
