FROM intellisrc/alpine:3.17

WORKDIR /home/
VOLUME ["/home/"]
# --------------- SYSTEM ------------------
ENV DB_USER=root
ENV DB_PASS=
ENV DB_HOST=localhost
ENV BACK_HOUR=0

RUN apk add --update --no-cache mariadb-client

COPY start.sh /usr/local/bin/start.sh

CMD [ "start.sh" ]
