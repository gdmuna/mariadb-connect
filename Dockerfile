######################################################
# ImageName : mariadb-connect
# Description : MariaDB DataBase with Connect Engine.
# Platform : amd64
# Author : Seele.Clover
# Copyright (c) 2024 by GDMU-NA, All Rights Reserved.
######################################################

# Get version from build-arg
ARG MARIADB_VERSION



######################################################
# downloader
######################################################

FROM ubuntu:latest as downloader

ARG MARIADB_VERSION=${MARIADB_VERSION}

WORKDIR /downloads

# Step 1: Download wrappers files and jdbc files
RUN apt-get update \
    && apt-get install -y wget \
    && wget https://archive.mariadb.org/mariadb-${MARIADB_VERSION}/bintar-linux-systemd-x86_64/mariadb-${MARIADB_VERSION}-linux-systemd-x86_64.tar.gz \
    && tar -zxvf mariadb-${MARIADB_VERSION}-linux-systemd-x86_64.tar.gz \
    && mkdir -p /downloads/wrapper \
    && cp -a mariadb-${MARIADB_VERSION}-linux-systemd-x86_64/share/JavaWrappers.jar /downloads/wrapper/ \
    && cp -a mariadb-${MARIADB_VERSION}-linux-systemd-x86_64/share/JdbcInterface.jar /downloads/wrapper/ \
    && wget https://download.oracle.com/otn-pub/otn_software/jdbc/233/ojdbc11.jar \
    && mkdir -p /downloads/jdbc \
    && mv ojdbc11.jar /downloads/jdbc/



######################################################
# mariadb
######################################################

FROM mariadb:${MARIADB_VERSION} as mariadb

ARG MARIADB_VERSION=${MARIADB_VERSION}

LABEL org.opencontainers.image.name="mariadb-connect" \
    org.opencontainers.image.description="MariaDB DataBase with Connect Engine." \
    org.opencontainers.image.version=${MARIADB_VERSION} \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.maintainer="Seele.Clover" \
    org.opencontainers.image.vendor="GDMU-NA" \
    org.opencontainers.image.repository="https://github.com/gdmuna/mariadb-connect" \
    org.opencontainers.image.url="https://hub.docker.com/r/gdmuna/mariadb-connect"

EXPOSE 3306
ENV LANG=C.UTF-8 \
    TZ=Asia/Shanghai \
    JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Step 2: Install connect engine plugin and openjdk
RUN apt-get update \
    && apt-get install -y --no-install-recommends mariadb-plugin-connect libodbc1 \
    && apt-get install -y --no-install-recommends openjdk-11-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Step 3: Copy wrapper files and jdbc files
COPY --from=downloader /downloads/wrapper/* /usr/share/mysql/
COPY --from=downloader /downloads/jdbc/* /usr/lib/jvm/java-11-openjdk-amd64/lib/

# Step 4: Copy configuration file
COPY my.cnf /etc/mysql/conf.d/
