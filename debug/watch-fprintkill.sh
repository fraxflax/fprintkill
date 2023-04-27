#!/bin/sh

# example usage:
# ../fprintkill sh -c 'sleep 111 & sleep 222 & sleep 333 &' & ./watch-fprintkill.sh sleep 

PGREP='pgrep -f fprintkill ; pgrep -x fprintd-verify'
for c in $@; do PGREP="$PGREP ; pgrep $c"; done
watch -n1 "(echo $$ ; eval \"$PGREP\") | xargs ps -oppid,pid,pgid,cmd "
