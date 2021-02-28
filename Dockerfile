# docker build
# docker build -t fulvio1982/debian-cups --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` .

# docker run
# docker run -d --restart always -p 631:631 --privileged -v /var/run/dbus:/var/run/dbus -v /dev/bus/usb:/dev/bus/usb -v /etc/cups:/etc/cups -p 631:631 -e ADMIN_PASSWORD=mySecretPassword

# base image
ARG ARCH=arm32v7
FROM $ARCH/debian:latest

# args
#ARG VCS_REF
ARG BUILD_DATE

# environment
ENV ADMIN_PASSWORD=admin

# labels
LABEL maintainer="Fulvio Capone" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.name="fulvio1982/debian-cups" \
  org.label-schema.description="Debian CUPS docker image" \
  org.label-schema.version="1.0" \
  org.label-schema.url="https://hub.docker.com/r/fulvio1982/debian-cups" \
  org.label-schema.build-date=$BUILD_DATE

# install packages
RUN apt-get update \
  && apt-get install -y \
  sudo \
  cron \
  rsyslog \
  cups \
  cups-bsd \
  cups-filters \
  printer-driver-gutenprint \
  foomatic-db-compressed-ppds \
  printer-driver-all \
  openprinting-ppds \
  hpijs-ppds \
  hp-ppd \
  hplip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# add print user
RUN adduser --home /home/admin --shell /bin/bash --gecos "admin" --disabled-password admin \
  && adduser admin sudo \
  && adduser admin lp \
  && adduser admin lpadmin

# disable sudo password checking
RUN echo 'admin ALL=(ALL:ALL) ALL' >> /etc/sudoers

# enable access to CUPS
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid) \
  && echo "ServerAlias *" >> /etc/cups/cupsd.conf \
  && echo 'DefaultEncryption IfRequested' >> /etc/cups/cupsd.conf

# add custom config to CUPS admin
RUN echo 'DefaultEncryption IfRequested' >> /etc/cups/cupsd.conf

# copy /etc/cups for skeleton usage
RUN cp -rp /etc/cups /etc/cups-skel

# entrypoint
# ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
# starting script files
RUN touch /usr/local/bin/docker-entrypoint.sh \
    && echo '#!/bin/bash -e' > /usr/local/bin/docker-entrypoint.sh \
    && echo '' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'service rsyslog start' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'service cron start' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'echo -e "${ADMIN_PASSWORD}\n${ADMIN_PASSWORD}" | passwd admin' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'if [ ! -f /etc/cups/cupsd.conf ]; then' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '  cp -rpn /etc/cups-skel/* /etc/cups/' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'fi' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'exec "$@"' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '' >> /usr/local/bin/docker-entrypoint.sh

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

# apt daily upgrade script
RUN touch /etc/cron.daily/apt-upgrade \
    && echo '#!/bin/bash' > /etc/cron.daily/apt-upgrade \
    && echo 'apt update' >> /etc/cron.daily/apt-upgrade \
    && echo 'apt upgrade -y' >> /etc/cron.daily/apt-upgrade \
    && echo 'apt autoremove -y' >> /etc/cron.daily/apt-upgrade \
    && echo 'apt clean' >> /etc/cron.daily/apt-upgrade

RUN chmod +x /etc/cron.daily/apt-upgrade

ENTRYPOINT [ "docker-entrypoint.sh" ]

# default command
CMD ["cupsd", "-f"]

# volumes
VOLUME ["/etc/cups"]
VOLUME ["/dev/bus/usb"]
VOLUME ["/var/run/dbus"]

# ports
EXPOSE 631
