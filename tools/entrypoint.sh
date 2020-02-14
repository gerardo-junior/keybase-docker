#!/bin/sh

if [ ! ${EUID} -ne 0 ]; then 
    /usr/bin/sudo /bin/chgrp -Rf ${USER} ${WORKDIR}
fi

if [ -e "${WORKDIR}/.env"]; then
    export $(/bin/grep -v '^#' ${WORKDIR}/.env | /user/bin/xargs -d '\n')
fi

if [ ! -z "$1" ]; then
    if [ -z "$(/usr/bin/which -- $1)" ]; then
        keybase "$@"
    else
        exec "$@"
    fi
fi

exit 1
