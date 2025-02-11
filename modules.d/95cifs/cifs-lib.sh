#!/bin/sh

# cifs_to_var CIFSROOT
# use CIFSROOT to set $server, $path, and $options.
# CIFSROOT is something like: cifs://[<username>[:<password>]]@<host>/<path>
# NETIF is used to get information from DHCP options, if needed.

command -v getarg > /dev/null || . /lib/dracut-lib.sh

cifs_to_var() {
    local cifsuser
    local cifspass
    # Check required arguments
    server=${1##cifs://}
    cifsuser=${server%@*}
    cifspass=${cifsuser#*:}
    if [ "$cifspass" != "$cifsuser" ]; then
        cifsuser=${cifsuser%:*}
    else
        cifspass=$(getarg cifspass)
    fi
    if [ "$cifsuser" != "$server" ]; then
        server="${server#*@}"
    else
        cifsuser=$(getarg cifsuser)
    fi

    # shellcheck disable=SC2034
    path=${server#*/}
    # shellcheck disable=SC2034
    server=${server%/*}

    if [ ! "$cifsuser" ] || [ ! "$cifspass" ]; then
        die "For CIFS support you need to specify a cifsuser and cifspass either in the cifsuser and cifspass commandline parameters or in the root= CIFS URL."
    fi
    # shellcheck disable=SC2034
    options="user=$cifsuser,pass=$cifspass,$(getarg rootflags=)"
}
