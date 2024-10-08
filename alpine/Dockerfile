FROM alpine:3.20

RUN apk add --no-cache ca-certificates libstdc++ su-exec libpq
RUN set -eux; \
    addgroup -g 9987 ts3server; \
    adduser -u 9987 -Hh /var/ts3server -G ts3server -s /sbin/nologin -D ts3server; \
    install -d -o ts3server -g ts3server -m 775 /var/ts3server /var/run/ts3server /opt/ts3server

ENV PATH="${PATH}:/opt/ts3server"

ARG TEAMSPEAK_CHECKSUM=359aac972679cfd98d62af51ddaf80e674cab166e13c6a835e81759097f9ba2e
ARG TEAMSPEAK_URL=https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_linux_alpine-3.13.7.tar.bz2

RUN set -eux; \
    apk add --no-cache --virtual .fetch-deps tar; \
    wget "${TEAMSPEAK_URL}" -O server.tar.bz2; \
    echo "${TEAMSPEAK_CHECKSUM} *server.tar.bz2" | sha256sum -c -; \
    mkdir -p /opt/ts3server; \
    tar -xf server.tar.bz2 --strip-components=1 -C /opt/ts3server; \
    rm server.tar.bz2; \
    apk del .fetch-deps; \
    mv /opt/ts3server/*.so /opt/ts3server/redist/* /usr/local/lib; \
    ldconfig /usr/local/lib

# setup directory where user data is stored
VOLUME /var/ts3server/
WORKDIR /var/ts3server/

ENV USER=docker
ENV GROUPNAME=$USER
ENV UID=2077
ENV GID=2077

RUN addgroup \
    --gid "$GID" \
    "$GROUPNAME" \
&&  adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$GROUPNAME" \
    --no-create-home \
    --uid "$UID" \
    $USER

RUN chown -R $USER: /opt/ts3server && \
    chown -R $USER: /var/run/ts3server && \
    chown -R $USER: /var/ts3server

USER $USER

#  9987 default voice
# 10011 server query
# 30033 file transport
EXPOSE 9987/udp 10011 30033 

COPY entrypoint.sh /opt/ts3server

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "ts3server" ]
