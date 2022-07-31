FROM debian:stable-20220711-slim
LABEL maintainer="maintainer@datoma.de"

# setup webmin Repo
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y gnupg curl ca-certificates \
 && curl https://download.webmin.com/jcameron-key.asc | gpg --dearmor >/usr/share/keyrings/jcameron-key.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/jcameron-key.gpg] https://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list


# args and vars
ARG BIND_USER=bind
ARG BIND_VERSION=9.16.27
ARG WEBMIN_VERSION=1.998
ARG DATA_DIR=/data

ENV BIND_USER=${BIND_USER} \
    BIND_VERSION=${BIND_VERSION} \
    WEBMIN_VERSION=${WEBMIN_VERSION} \
    DATA_DIR=${DATA_DIR}

# install packages needed
RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      bind9=1:${BIND_VERSION}* bind9-host=1:${BIND_VERSION}* bind9utils=1:${BIND_VERSION}* dnsutils \
      webmin=${WEBMIN_VERSION}* \
 && rm -rf /var/lib/apt/lists/*

# entrypoint
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

# ports
EXPOSE 53/udp 53/tcp 10000/tcp

# commands
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
