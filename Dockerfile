FROM alpine:3.8

RUN \
    apk --no-cache add --repository https://uk.alpinelinux.org/alpine/edge/testing confd && \
    apk --no-cache add suricata py2-pip && \
    pip2 install --no-cache pyyaml suricata-update && \
    addgroup -g 2000 suricata && \
    adduser -S -H -u 2000 -D -g 2000 suricata

COPY suricata-logrotate /usr/bin/suricata-logrotate
COPY suricata.yaml /etc/confd/templates/suricata.yaml
COPY suricata.yaml.toml /etc/confd/conf.d/suricata.yaml.toml
COPY disable.conf /etc/confd/templates/disable.conf
COPY disable.conf.toml /etc/confd/conf.d/disable.conf.toml
COPY entrypoint.sh /docker-entrypoint.sh

VOLUME /var/lib/suricata

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/suricata", "--pidfile", "/var/run/suricata/suricata.pid", "-i", "eth0"]
