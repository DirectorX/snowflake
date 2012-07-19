#!/bin/sh
cd /var/pkgsrc
LOG="/root/pkgsrc.log"

SKIP=no
CONTINUE=

# groups that are needed
for g in dbus
do
    addgroup $g 2> /dev/null
done

try() {
    "$@"
    RET="$?"
    test "$RET" = "0" && echo -n ' |' >> "$LOG" || echo -n 'X|' >> "$LOG"
    return "$RET"
}

[ "$SKIP" != "yes" ] && echo '
D|B|T|pkg
-+-+-+---' > "$LOG"

for pkg in */*/Makefile
do
    pkg=`dirname $pkg`

    if [ "$SKIP" = "yes" ]
    then
        [ "$pkg" != "$CONTINUE" ] && continue
        SKIP=no
        continue
    fi

    expr "$pkg" : '.*/gcc' && continue
    expr "$pkg" : '.*/binutils' && continue
    cd $pkg
    if try with pkgsrc -- bmake depends
    then
        if try with pkgsrc -- bmake
        then
            try with pkgsrc -- bmake test
            with pkgsrc -- bmake install
        else
            echo -n 'X|' >> "$LOG"
        fi
    else
        echo -n '-|-|' >> "$LOG"
    fi
    echo "$pkg" >> "$LOG"
    cd /var/pkgsrc
done