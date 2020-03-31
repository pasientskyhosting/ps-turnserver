#!/bin/bash
if [ ! -d /metrics ]; then
    mkdir -p /metrics
fi

while true;
do

    d1=$(date --date="-5 min" "+%b %_d %H:%M")
    d2=$(date "+%b %_d %H:%M")
    echo -e '# HELP turnserver_quota_exceeded_detected Integer boolean if bandwidth allocation has happen.\n# TYPE turnserver_quota_exceeded_detected counter' > /metrics/turnserver_quota_exceeded_detected.prom
    found=0
    if [ ! -f /var/log/syslog ]; then
        echo 'turnserver_quota_exceeded_detected{hostname="'${HOSTNAME}'"}' 0 >> /metrics/turnserver_quota_exceeded_detected.prom
    else
        while IFS= read -r line; do
            if [[ $line > $d1 && $line < $d2 || $line =~ $d2 ]]; then
                if echo "$line" | grep "Allocation Bandwidth Quota Reached" > /dev/null; then
                    echo 'turnserver_quota_exceeded_detected{hostname="'${HOSTNAME}'"}' 1 >> /metrics/turnserver_quota_exceeded_detected.prom
                    found=1
                fi
            fi
        done < /var/log/syslog

        if [ $found == "0" ]; then
            echo 'turnserver_quota_exceeded_detected{hostname="'${HOSTNAME}'"}' 0 >> /metrics/turnserver_quota_exceeded_detected.prom
        fi
    fi

    logrotate /etc/logrotate.conf
    sleep 60
done

exit 0
