FROM debian:buster-slim

RUN groupadd -r mysql && \
    apt-get update && \
    apt-get install -y --no-install-recommends gnupg dirmngr && \
    rm -rf /var/lib/apt/lists/*

ENV GOSU_VERSION=1.10-1+b23

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu="$GOSU_VERSION" \
        wget ca-certificates \
        perl \
        pwgen \
    ; \
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

ENV MYSQL_MAJOR=8.0
ENV MYSQL_VERSION=8.0.33
ENV PUBKEY=467B942D3A79BD29

RUN echo 'deb http://repo.mysql.com/apt/debian/ buster mysql-8.0' > /etc/apt/sources.list.d/mysql.list && \
    { \
        echo 'mysql-apt-config mysql-apt-config/enable-repo select mysql-8.0'; \
        echo 'mysql-apt-config mysql-apt-config/select-server select mysql-8.0'; \
    } | debconf-set-selections && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "${PUBKEY}" && \
    apt-get update && \
    apt-get install -y --no-install-recommends mysql-community-server="${MYSQL_VERSION}" && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/log/mysql && \
    mkdir -p /var/log/mysql && \
    chown -R mysql:mysql /var/log/mysql && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

VOLUME /var/lib/mysql

COPY ./my.cnf /etc/mysql/my.cnf
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mysqld"]
