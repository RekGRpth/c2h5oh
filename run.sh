#!/bin/sh

#docker build --tag rekgrpth/c2h5oh . || exit $?
#docker push rekgrpth/c2h5oh || exit $?
docker stop c2h5oh
docker rm c2h5oh
docker pull rekgrpth/c2h5oh || exit $?
docker volume create c2h5oh || exit $?
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env USER_ID=$(id -u) \
    --hostname c2h5oh \
    --name c2h5oh \
    --publish 8443:443 \
    --restart always \
    --volume /etc/certs/t72.crt:/etc/c2h5oh_nginx/ssl/t72.crt:ro \
    --volume /etc/certs/t72.key:/etc/c2h5oh_nginx/ssl/t72.key:ro \
    --volume c2h5oh:/data/c2h5oh \
    --volume /var/lib/docker/volumes/c2h5oh/_data/c2h5oh.conf:/etc/c2h5oh_nginx/conf.d/c2h5oh.conf:ro \
    --volume /var/lib/docker/volumes/c2h5oh/_data/log:/var/log/nginx \
    rekgrpth/c2h5oh
