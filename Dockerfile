FROM alpine:3.4
ARG VERSION
MAINTAINER Chris Garrett (https://github.com/chris-garrett/docker-alpine)
LABEL description="Alpine 3.4 Custom Image"
RUN apk --no-cache add git bash make curl
RUN apk add -U alpine-sdk linux-headers \
    && curl ftp://ftp.isc.org/isc/bind9/9.10.2/bind-9.10.2.tar.gz|tar -xzv \
    && cd bind-9.10.2 \
    && CFLAGS="-static" ./configure --without-openssl --disable-symtable \
    && make \
    && cp ./bin/dig/dig /usr/bin/ \
    && apk del alpine-sdk linux-headers \
    && rm -rf bind-9.10.2/
CMD bash
