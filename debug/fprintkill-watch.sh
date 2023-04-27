#!/bin/sh
sh `dirname $0`/../fprintkill "$@" &
watch -n1 "(echo $$ ; pgrep fprintkill ; pgrep fprintd-verify ; pgrep '$1' ) | xargs ps -oppid,pid,pgid,cmd "
