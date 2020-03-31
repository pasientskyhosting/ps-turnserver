#!/bin/bash
if [ ! -d /metrics ]; then
    echo "Missing /metrics folder"
    exit 1
fi

while true;
do
    echo -e '# HELP clamav_virus_detected Total number of viruses detected.\n# TYPE clamav_virus_detected counter' > /metrics/turnserver_quota_detected.prom
    if [ ! -f /detected.log ] && [[ $(tr -d "\r\n" < /detected.log|wc -c) -eq 0 ]] &>/dev/null; then
        echo 'clamav_virus_detected{hostname="'${HOSTNAME}'"}' 0 >> /metrics/turnserver_quota_detected.prom
    else
        echo 'clamav_virus_detected{hostname="'${HOSTNAME}'"}' $(wc -l /detected.log | awk '{print $1}') >> /metrics/turnserver_quota_detected.prom
    fi
    sleep 120
done

exit 0
