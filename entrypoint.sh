#!/bin/bash
set -e

service ssh start

if [ ! -f "/root/.vnc/passwd" ]; then
    echo "vncpassword" | vncpasswd -f > /root/.vnc/passwd
    chmod 600 /root/.vnc/passwd
fi

vncserver :1 -geometry 680x820 -depth 16

tail -f /dev/null
