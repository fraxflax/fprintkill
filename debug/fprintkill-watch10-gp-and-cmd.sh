#!/bin/sh

# example usage:
# sh fprintkill-watch-gp-and-cmd.sh sleep sh -c 'sleep 111 & sleep 222 & sleep 333 &'

mypgid=`ps -opgid= $$`
mycomm=`basename $0 | cut -c-15`


fprintkill=fprintkill
for f in "`dirname $0`/../fprintkill" "`dirname $0`/fprintkill.debug" ./fprintkill.debug; do
    test -r "$f" && fprintkill="$f";
done
FPK_EXEC="$2" ; export FPK_EXEC
n=3
while eval "test -n \"\$$n\""; do
    eval "FPK_ARGS=\"$FPK_ARGS '\$$n'\""
    n=$((n+1))
done
export FPK_ARGS
echo "~~~ $fprintkill: $0 $@" > /tmp/fprintkill-watch.$$.log
( while ps $$ >/dev/null 2>&1; do sleep 1; done ; echo ; rm -v /tmp/fprintkill-watch.$$.log ) &
sh "$fprintkill" "$@" >>/tmp/fprintkill-watch.$$.log 2>&1 &
watch -n10 "
cat /tmp/fprintkill-watch.$$.log ;
echo ~~~ Process Grupp ;
pgrep -x fprintd-verify >/dev/null &&
{ pgrep -x fprintd-verify | xargs ps -opgid= | xargs pgrep -g | xargs ps -opgid,ppid,pid,cmd; };
echo ~~~ pgrep cmds ;
(pgrep -x fprintd-verify ; pgrep -f fprintkill ; pgrep '$1') | xargs ps -opgid,ppid,pid,cmd,comm \
| grep -vE '^\\s*$mypgid\\s.*\\s+grep\$' \
| grep -vE '^\\s*$mypgid\\s.*\\s+watch\$' \
| grep -vE '^\\s*$mypgid\\s.*\\s+$mycomm\$' \
| grep -vE '^\\s*$mypgid\\s.*\\ssh $mycomm.*\\s+sh\$' \
| grep -vE '^\\s*$mypgid\\s.*\\scat /tmp/fprintkill.*\\ssh\$' \
| grep -vE '^\\s*$mypgid\\s.*\\ssleep 1\\s+sleep\$' \
;"
