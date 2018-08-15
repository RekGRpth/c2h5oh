FROM alpine

MAINTAINER RekGRpth

ADD entrypoint.sh /

ADD c2h5oh_nginx /etc/c2h5oh_nginx/

ENV HOME=/data/c2h5oh \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=c2h5oh \
    GROUP=c2h5oh

RUN apk add --no-cache \
        alpine-sdk \
        cmake \
        git \
        libgcc \
        libpq \
        libstdc++ \
        pcre \
        pcre-dev \
        postgresql-dev \
        shadow \
        tzdata \
        zlib-dev \
    && (git clone https://github.com/RekGRpth/c2h5oh.git && cd c2h5oh && make release) \
    && rm -rf c2h5oh \
    && apk del \
        alpine-sdk \
        cmake \
        git \
        pcre-dev \
        postgresql-dev \
        zlib-dev \
    && chmod +x /entrypoint.sh \
    && mkdir -p "${HOME}" \
    && groupadd --system "${GROUP}" \
    && useradd --system --gid "${GROUP}" --home-dir "${HOME}" --shell /sbin/nologin "${USER}" \
    && chown -R "${USER}":"${GROUP}" "${HOME}" \
    && usermod --home "${HOME}" "${USER}"

VOLUME  ${HOME}

WORKDIR ${HOME}

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "c2h5oh_nginx" ]
