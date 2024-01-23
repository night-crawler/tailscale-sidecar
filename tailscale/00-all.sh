#!/command/with-contenv bash
# shellcheck shell=bash

set -ex

echo "key: $TS_AUTHKEY"

tailscale up \
  --login-server=$TS_LOGIN_SERVER \
  --authkey=$TS_AUTHKEY \
  --accept-dns=false \
  --hostname=$TS_HOSTNAME
