#!/bin/sh
PGREP='pgrep fprintkill ; pgrep fprintd-verify'
for c in $@; do PGREP="$PGREP ; pgrep $c"; done
watch -n1 "(echo $$ ; eval \"$PGREP\") | xargs ps -oppid,pid,pgid,cmd "
