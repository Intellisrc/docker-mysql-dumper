FROM intellisrc/alpine:edge

WORKDIR /home/
VOLUME ["/home/"]
# --------------- SYSTEM ------------------
ENV DB_USER=root
ENV DB_PASS=
ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_SSL=false
ENV BACK_HOUR=

RUN apk add --update --no-cache mariadb-client

COPY start.sh /usr/local/bin/start.sh

CMD [ "start.sh" ]
