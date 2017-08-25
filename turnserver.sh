#!/bin/bash
if [ -z $EXTERNAL_IP ]
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
    echo listening-port=$PORT >> /etc/turnserver.conf

    if [ ! -z $LISTENING_IP ]
    then
        echo listening-ip=$LISTENING_IP >> /etc/turnserver.conf
    fi

    if [ ! -z $EXTERNAL_IP ]
    then
        #echo relay-ip=$EXTERNAL_IP >> /etc/turnserver.conf
        echo external-ip=$EXTERNAL_IP >> /etc/turnserver.conf
    fi

    if [ ! -z $RELAY_IP ]
    then
        echo relay-ip=$RELAY_IP >> /etc/turnserver.conf
    fi

    if [ ! -z $MYSQL_HOST ] && [ ! -z $MYSQL_DB ] && [ ! -z $MYSQL_USER ] && [ ! -z $MYSQL_PW ];
    then
        echo "mysql-userdb=\"host=$MYSQL_HOST dbname=$MYSQL_DB user=$MYSQL_USER password=$MYSQL_PW\"" >> /etc/turnserver.conf
    fi

    touch /tmp/turnserver.configured
fi

exec /usr/bin/turnserver


turnserver -L INT_IP -r someRealm -X EXT_IP/INT_IP  --no-dtls --no-tls
