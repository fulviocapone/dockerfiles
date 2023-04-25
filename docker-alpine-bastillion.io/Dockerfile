FROM alpine:latest

RUN apk --update add --no-cache java-cacerts sudo zlib bash curl dcron tzdata gzip tar openjdk17 grep wget openssh-keygen

RUN set eux; \
    curl -s https://api.github.com/repos/bastillion-io/Bastillion/releases/latest | \
    grep "browser_download_url.*bastillion-jetty-*" | \
    cut -d : -f 2,3 | \
    tr -d '"' | \
    wget -i - -O /tmp/bastillion.tar.gz

RUN tar -xzvf /tmp/bastillion.tar.gz -C /opt
RUN mkdir /opt/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/keydb

# Add configurations
ADD add/bastillion.io/start.ini /opt/Bastillion-jetty/jetty/
ADD add/bastillion.io/bastillion.mv.db /opt/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/keydb/
ADD add/bastillion.io/BastillionConfig.properties /opt/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/
ADD add/bastillion.io/bastillion.jceks /opt/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/

# Add startup script
ADD add/sh/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

#Add daily update script
ADD add/sh/daily-apk-upgrade /etc/cron.daily/daily-apk-upgrade
RUN chmod a+x /etc/cron.daily/daily-apk-upgrade

# persistent data of Bastillion is stored here
VOLUME /opt/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/keydb

# this is the home of Bastillion
WORKDIR /opt/Bastillion-jetty

# Bastillion listens on 8080 - HTTP
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s CMD curl --fail http://localhost:8080|| exit 1

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]