#!/bin/sh

if [ "$GROUP_ID" = "" ]; then GROUP_ID=$(id -g "$GROUP"); fi
if [ "$GROUP_ID" != "$(id -g "$GROUP")" ]; then
    find / -group "$GROUP" -exec chgrp "$GROUP_ID" {} \;
    groupmod --gid "$GROUP_ID" "$GROUP"
fi

if [ "$USER_ID" = "" ]; then USER_ID=$(id -u "$USER"); fi
if [ "$USER_ID" != "$(id -u "$USER")" ]; then
    find / -user "$USER" -exec chown "$USER_ID" {} \;
    usermod --uid "$USER_ID" "$USER"
fi

#sed -i "/^\tinclude \/etc\/c2h5oh\/conf\.d\/\*\.conf/cinclude \/data\/\*\/c2h5oh\.conf;" "/etc/c2h5oh/c2h5oh.conf"
#sed -i "/^\taccess_log/caccess_log \/data\/c2h5oh\/log\/access\.log main;" "/etc/c2h5oh/c2h5oh.conf"
#sed -i "/^error_log/cerror_log \/data\/c2h5oh\/log\/error\.log warn;" "/etc/c2h5oh/c2h5oh.conf"
#sed -i "/^worker_processes/cworker_processes 2;" "/etc/c2h5oh/c2h5oh.conf"

mkdir -p /var/log/c2h5oh /var/lib/c2h5oh/nginx_body

find "$HOME" ! -group "$GROUP" -exec chgrp "$GROUP_ID" {} \;
find "$HOME" ! -user "$USER" -exec chown "$USER_ID" {} \;

exec "$@"
