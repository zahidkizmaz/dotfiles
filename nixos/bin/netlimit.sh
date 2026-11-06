#!/usr/bin/env bash
set -euo pipefail

IFACE="${IFACE:-$(ip route show default | awk 'NR==1{print $5}')}"

usage() {
  cat >&2 <<EOF
usage: ${0##*/} [DOWN [UP]] [clear]
  DOWN/UP in kbit/s (default DOWN=3000, UP=1000)
  clear   remove limits
  IFACE env overrides interface (default: $IFACE)
EOF
  exit 1
}

[[ $EUID -eq 0 ]] || {
  echo "run as root (needs tc)" >&2
  exit 1
}
[[ -n $IFACE ]] || {
  echo "could not detect interface; set IFACE=" >&2
  exit 1
}

clear() {
  tc qdisc del dev "$IFACE" ingress 2>/dev/null || true
  tc qdisc del dev "$IFACE" root 2>/dev/null || true
}

case "${1:-}" in
  clear | off | stop)
    clear
    echo "cleared limits on $IFACE"
    exit 0
    ;;
  "" | -h | --help)
    usage
    ;;
esac

DOWN="${1:-5000}"
UP="${2:-1000}"

[[ $DOWN =~ ^[0-9]+$ && $UP =~ ^[0-9]+$ ]] || usage

clear

# ingress policing -> download cap
tc qdisc add dev "$IFACE" handle ffff: ingress
tc filter add dev "$IFACE" parent ffff: protocol ip prio 1 \
  u32 match u32 0 0 police rate "${DOWN}kbit" burst 100k drop flowid :1

# tbf -> upload cap
tc qdisc add dev "$IFACE" root tbf rate "${UP}kbit" burst 32kbit latency 400ms

echo "limited $IFACE: down ${DOWN}kbit up ${UP}kbit (run '${0##*/} clear' to reset)"
