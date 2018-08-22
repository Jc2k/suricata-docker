FROM alpine:3.8

RUN \
    apk --no-cache add --repository https://dl-cdn.alpinelinux.org/alpine/3.8/community suricata && \
    apk --no-cache add python3 && \
    python3 -m pip install --no-cache pyyaml suricata-update && \
    addgroup -g 2000 suricata && \
    adduser -S -H -u 2000 -D -g 2000 suricata

COPY suricata-logrotate /usr/bin/suricata-logrotate
COPY suricata.yaml /etc/suricata/suricata.yaml
COPY entrypoint.sh /docker-entrypoint.sh

VOLUME /var/lib/suricata

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/suricata", "--pidfile", "/var/run/suricata/suricata.pid", "-i", "eth0"]
