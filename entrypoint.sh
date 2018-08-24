#!/bin/sh
set -eo pipefail

confd -onetime -backend env -confdir /etc/confd

if [ ! -d /var/lib/suricata/alerts ]; then
    mkdir -p /var/lib/suricata/alerts
fi

if [ ! -f /var/lib/suricata/rules/suricata.rules ]; then
    suricata-update update-sources
    suricata-update enable-source et/open || true
    suricata-update
fi

exec "$@"
