#!/bin/sh

# example usage:
# ./fprintkill-watch.sh xtrlock -f

echo ~~~ /tmp/fprintkill-watch.$$.log ~~~ > /tmp/fprintkill-watch.$$.log
( while ps $$ >/dev/null 2>&1; do sleep 1; done ; rm -v /tmp/fprintkill-watch.$$.log ) &
sh `dirname $0`/../fprintkill "$@" >>/tmp/fprintkill-watch.$$.log 2>&1 &
watch -n1 "(echo $$ ; pgrep fprintkill ; pgrep fprintd-verify ; pgrep '$1') | xargs ps -oppid,pid,pgid,cmd ; cat /tmp/fprintkill-watch.$$.log "
