FROM alpine:3.4
ARG VERSION
MAINTAINER Chris Garrett (https://github.com/chris-garrett/docker-alpine)
LABEL description="Alpine 3.4 Custom Image"

RUN apk --no-cache add -U git bash make curl wget

RUN apk add -U alpine-sdk linux-headers libintl gettext \
    && curl ftp://ftp.isc.org/isc/bind9/9.10.2/bind-9.10.2.tar.gz|tar -xzv \
    && cd bind-9.10.2 \
    && CFLAGS="-static" ./configure --without-openssl --disable-symtable \
    && make \
    && cp ./bin/dig/dig /usr/bin/ \
    && cp /usr/bin/envsubst /tmp/envsubst \
    && apk del alpine-sdk linux-headers gettext \
    && mv /tmp/envsubst /usr/bin/envsubst \
    && rm -rf /bind-9.10.2/

ARG DOCKERIZE_VERSION=v0.3.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN adduser -s /bin/bash -D sprout

COPY ./bash_aliases /home/sprout/.bashrc
COPY ./vimrc /home/sprout/.vimrc
RUN chown sprout:sprout /home/sprout/.bashrc /home/sprout/.vimrc \
  && ln -sf /usr/bin/vim /usr/bin/vi

USER sprout

CMD bash
