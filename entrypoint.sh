#!/bin/bash
set -e
export USER=root
echo "root:${PASSWORD}" | chpasswd

service ssh start

if [ ! -f "/root/.vnc/passwd" ]; then
    echo "${PASSWORD}" | vncpasswd -f > /root/.vnc/passwd
    chmod 600 /root/.vnc/passwd
fi

vncserver :1 -geometry 680x820 -depth 16

tail -f /dev/null
