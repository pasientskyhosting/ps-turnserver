#!/bin/bash
if [ -z "$EXTERNAL_IP" ]
then
    if [ -n "$USE_IPV4" ]
    then
        EXTERNAL_IP=$(curl -4 icanhazip.com 2> /dev/null)
    else
        EXTERNAL_IP=$(curl icanhazip.com 2> /dev/null)
    fi
fi

if [ -z "$PORT" ]
then
    PORT=3478
fi

if [ -z "$MYSQL_PORT" ]
then
    MYSQL_PORT=3306
fi

if [ ! -e /tmp/turnserver.configured ]
then
    echo listening-port=$PORT >> /etc/turnserver.conf

    if [ -n "$LISTENING_IP" ]
    then
        echo "listening-ip=$LISTENING_IP" >> /etc/turnserver.conf
    fi

    if [ -n "$EXTERNAL_IP" ]
    then
        echo "external-ip=$EXTERNAL_IP" >> /etc/turnserver.conf
    fi

    if [ -n "$RELAY_IP" ]
    then
        echo "relay-ip=$RELAY_IP" >> /etc/turnserver.conf
    fi

    if [ -n "$MAX_BPS" ]
    then
        echo "max-bps=$MAX_BPS" >> /etc/turnserver.conf
    fi

    if [ -n "$BPS_CAPACITY" ]
    then
        echo "bps-capacity=$BPS_CAPACITY" >> /etc/turnserver.conf
    fi

    if [ -n "$MYSQL_HOST" ] && [ -n "$MYSQL_DB" ] && [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PW" ];
    then
        echo "mysql-userdb=\"host=$MYSQL_HOST dbname=$MYSQL_DB user=$MYSQL_USER password=$MYSQL_PW port=$MYSQL_PORT connect_timeout=5 read_timeout=5\"" >> /etc/turnserver.conf
    fi

    touch /tmp/turnserver.configured
fi

# /usr/sbin/rsyslogd
exec /usr/bin/turnserver -c /etc/turnserver.conf --prod
