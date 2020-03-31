FROM debian:buster-slim
MAINTAINER Andreas Krüger <ak@patientsky.com>

COPY bin/* /

RUN apt-get update && apt-get dist-upgrade -y && \
 apt-get update -y && \
 apt-get install coturn net-tools supervisor -y && \
 apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
 chmod +x /metrics.sh && \
 chmod +x /turnserver.sh

COPY conf/* /etc/

EXPOSE 3478/udp
EXPOSE 49152-65000/udp

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
