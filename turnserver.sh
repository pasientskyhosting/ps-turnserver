#!/bin/bash
if [ -z $SKIP_AUTO_IP ] && [ -z $EXTERNAL_IP ]
then
    if [ ! -z USE_IPV4 ]
    then
        EXTERNAL_IP=`curl -4 icanhazip.com 2> /dev/null`
    else
        EXTERNAL_IP=`curl icanhazip.com 2> /dev/null`
    fi
fi

if [ -z $PORT ]
then
    PORT=3478
fi

if [ ! -e /tmp/turnserver.configured ]
then
    if [ -z $SKIP_AUTO_IP ]
    then
        echo relay-ip=$EXTERNAL_IP >> /etc/turnserver.conf
        echo external-ip=$EXTERNAL_IP >> /etc/turnserver.conf
    fi
    echo listening-port=$PORT >> /etc/turnserver.conf

    if [ ! -z $LISTEN_ON_PUBLIC_IP ]
    then
        echo listening-ip=$EXTERNAL_IP >> /etc/turnserver.conf
    fi

    if [ ! -z $MYSQL_HOST ] && [ ! -z $MYSQL_DB ] && [ ! -z $MYSQL_USER ] && [ ! -z $MYSQL_PW ];
    then
        echo "mysql-userdb=\"host=$MYSQL_HOST dbname=$MYSQL_DB user=$MYSQL_USER password=$MYSQL_PW\"" >> /etc/turnserver.conf
    fi

    touch /tmp/turnserver.configured
fi

exec /usr/bin/turnserver
