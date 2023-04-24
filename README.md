# fprintkill
fprintkill is a simple, pure bourne shell, script that allows you to launch any executable and have it terminated by fingerprint... especially useful for screen-lockers that do not support fingerprint unlocking.

I do like to use simple lightweight screen lockers like xtrlock or slock and have them launched by xautolock. They have low impact on the system and gives me full control to tweak exactly how I like them to work (have wrappers shutting off the screen, additional notify warnings before locking via yad, etc, etc).

BUT now that we have fingerprint readers on almost all laptops I also do want to be able to unlock my computer using that ... which those lockers do not support, not even via libpam-fprintd, so to fix that dilemma I wrote this small script fixing the problem.

__EXAMPLES:__\
I primarily use fprintkill in a wrapper script __/usr/local/bin/xtrlock__:
```shell
#!/bin/sh
EXEC=/usr/bin/xtrlock
test -x $EXEC || { 
    echo "Executable '$EXEC' not present!" >/dev/stderr
    exit 1
}
which fprintkill >/dev/null || $EXEC "$@"
FORK=
ARGS=
for arg in $@; do
    if [ "$arg" = "-f" ]; then
	FORK='&'
    else
	ARGS="$ARGS $arg"
    fi
done
eval "exec fprintkill $EXEC $ARGS $FORK"
```
As I have /usr/local/bin before /usr/bin in my $PATH it serves as a transparent xtrlocker replacement (wrapper). OBSERVE the full path to the "real" xtrlock in the wrapper and that I take care of the '-f' (fork / run as daemon) option! The way the arguments are handled does not forward on arguments containing whitespaces correctly, but that is of no consequence as the only arguments xtrlock supports are '-b' and '-f'.

My __/usr/local/bin/slock__ is slightly simpler since slock does not have options for running as a daemon, however it has the option to some command once locked, so we need to handle potential whitespaces in the arguments:
```shell
#!/bin/sh
EXEC=/usr/bin/slock
test -x $EXEC || { 
    echo "Executable '$EXEC' not present!" >/dev/stderr
    exit 1
}
which fprintkill >/dev/null || $EXEC "$@"
eval "exec fprintkill $EXEC \"$@\""[/CODE]
```
