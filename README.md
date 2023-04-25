# fprintkill
fprintkill is a simple, pure bourne shell, script that allows you to launch any executable and have it terminated by fingerprint... especially useful for screen-lockers that do not support fingerprint unlocking.

I do like to use simple lightweight screen lockers like xtrlock or slock and have them launched by xautolock. They have low impact on the system and gives me full control to tweak exactly how I like them to work (have wrappers shutting off the screen, additional notify warnings before locking via yad, etc, etc).

BUT now that we have fingerprint readers on almost all laptops I also do want to be able to unlock my computer using that ... which those lockers do not support, not even via libpam-fprintd, so to fix that dilemma I wrote this small script fixing the problem.

__SYNOPSIS:__ <br/>

> __fprintkill__ [ cmd [ arg ...] ]

Executes cmd [ arg ...] and for as long as cmd is running, 
upon successfull fingerprint verify, cmd is terminated.

The fingerprint termination depends on  <br/>
'fprintd-verify', 'pgrep', 'pkill', 'ps', 'sed' and 'setsid'.  <br/>
If they are not found, a warning will be printed to stderr but the cmd will still
be launched, even though it cannot be killed by fingerprint.  <br/>
(To satisfy the dependencies in Debian/Ubuntu: apt install util-linux procps sed fprintd util-linux).

If no arguments are given to fprintkill, 
enviroment variables FPK_EXEC and FPK_ARGS are used for cmd [ arg ...]

__EXAMPLES:__ <br/>

Lock the screen with slock, terminating it upon verified fingerprint:
> fprintkill slock

Run '/usr/bin/xtrlock -b' in the background terminating it upon verified fingerprint:
> fprintkill /usr/bin/xtrlock -b &

Alternative using environment variables:
> env FPK_EXEC=/usr/bin/xtrlock FPK_ARGS=-b fprintkill &

Arguments with whitespaces are ok:
> fprintkill sh -c "xset dpms force off ; xtrlock" &

Alternative using environment variables:
> env FPK_EXEC=sh FPK_ARGS='-c  "xset dpms force off ; xtrlock"' &

Also daemons are properly handled.  To launch xtrlock in the background as a daemon that
will be terminated upon verified fingerprint:
> fprintkill xtrlock -f

In the case a daemon forks off several parallel processes before exiting, all of those
will be monitored and terminated upon verified fingerprint. Cleanup will not be performed
before all of the parallell processes have exited or have been terminated. In this example,
if proc1 exits, fprintkill will keep monitoring proc2 and proc3. If proc1, proc2 and proc3
all exits fprintkill will clean up. Upon verified fingerprint, proc1, proc2 and proc3
(and their child processes, if any) will be terminated:
> fprintkill sh -c "proc1 & proc2 & proc3 & exit 0"


__SCRIPT EXAMPLES:__ <br/>

I primarily use fprintkill in "wrapper" scripts, e.g. __/usr/local/bin/xtrlock__
```shell
#!/bin/sh
EXEC=/usr/bin/xtrlock
test -x $EXEC || { 
    echo "Executable '$EXEC' not present!" >/dev/stderr
    exit 1
}
which fprintkill >/dev/null || exec $EXEC "$@"
eval "exec fprintkill $EXEC \"$@\""
```
having /usr/local/bin preceed /usr/bin in my path the script becomes a transparent wrapper for slock allowing me to unlock using fingerprint.

Please, see the examples folder for more examples:\
https://github.com/fraxflax/fprintkill/tree/main/examples
