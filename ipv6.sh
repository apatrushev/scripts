#!/bin/bash
[ -z "$(which ip 2>/dev/null)" ] && echo "Cannot find iproute2" >&2 && exit 1
IP4IF=eth1
IP4ADDR=`ip addr show dev "$IP4IF" | fgrep "inet " | sed "s/.*inet //;s/\/.*//"`
IP6ADDR=`printf "2002:%02x%02x:%02x%02x::1\n" $(echo $IP4ADDR | tr . ' ')`
ip tunnel del tun1
ip tunnel add tun1 mode sit ttl 100 remote any local "$IP4ADDR"
ip link set dev tun1 up
ip -6 addr add "$IP6ADDR"/16 dev tun1
