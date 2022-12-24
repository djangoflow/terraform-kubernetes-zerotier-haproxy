#!/bin/sh
if "$MASQUERADE" == "true"
then
  COMMAND="iptables-legacy -t nat -A POSTROUTING -o eth0 -j MASQUERADE"
  echo "=> $COMMAND"
  sh -c "$COMMAND"
fi
exec /entrypoint.sh "$@"
