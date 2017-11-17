#!/usr/bin/env bash

CMD="data/$2"

echo $1 | openconnect --no-cert-check --juniper https://global.remoteaccess.hp.com --authgroup="OATH Passcode" -u W22051837 --passwd-on-stdin -b
echo "Connected to VPN"
sleep 3
export PATH=/opt/vertica/bin:$PATH
/bin/bash -c $CMD
#ping -c 5 shr4-vrt-pro-vglb1.houston.hp.com