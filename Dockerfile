#
# Dockerfile for shadowsocks-libev
#

FROM alpine
MAINTAINER EasyPi Software Foundation

ENV SS_VER 2.5.3
ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VER.tar.gz
ENV SS_DIR shadowsocks-libev-$SS_VER

RUN set -ex \
    && apk add --no-cache pcre \
    && apk add --no-cache \
               --virtual TMP autoconf \
                             build-base \
                             curl \
                             libtool \
                             linux-headers \
                             openssl-dev \
                             pcre-dev \
    && curl -sSL $SS_URL | tar xz \
    && cd $SS_DIR \
        && ./configure --disable-documentation \
        && make install \
        && cd .. \
        && rm -rf $SS_DIR \
    && apk del --virtual TMP

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV METHOD      aes-256-cfb
ENV PASSWORD=
ENV TIMEOUT     60
ENV DNS_ADDR    8.8.8.8

EXPOSE $SERVER_PORT/tcp
EXPOSE $SERVER_PORT/udp

CMD ss-server -s "$SERVER_ADDR" \
              -p "$SERVER_PORT" \
              -m "$METHOD"      \
              -k "$PASSWORD"    \
              -t "$TIMEOUT"     \
              -d "$DNS_ADDR"    \
              -u                \
              -A                \
              --fast-open
