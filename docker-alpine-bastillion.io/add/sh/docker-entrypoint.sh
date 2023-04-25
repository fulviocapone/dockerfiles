#!/usr/bin/env bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$JAVA_HOME/bin:$PATH

#FILE=/opt/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/keydb/id_rsa.pub
#if [ ! -f "$FILE" ]; then
#    ssh-keygen -t rsa -N "zz9T1NKurGtbSnLKoxNxNmDFBHEb2Mq0" -f /opt/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/keydb/id_rsa.pub
#fi

/opt/Bastillion-jetty/startBastillion.sh