#!/bin/bash
set -e
export USER=root
echo "root:${PASSWORD}" | chpasswd

service ssh start

if [ ! -f "/root/.vnc/passwd" ]; then
    echo "${PASSWORD}" | vncpasswd -f > /root/.vnc/passwd
    chmod 600 /root/.vnc/passwd
fi

echo " "
echo "Checking for and removing stale VNC lock and temporary files..."
if [ -f /tmp/.X1-lock ]; then
    echo " "
    echo "Found stale /tmp/.X1-lock file. Removing it..."
    rm -f /tmp/.X1-lock
fi
if [ -d /tmp/.X11-unix ]; then
    echo " "
    echo "Removing stale /tmp/.X11-unix directory..."
    rm -rf /tmp/.X11-unix
fi

echo " "
echo "Stopping any existing VNC server processes..."
pkill -f "Xvnc" || echo "No existing VNC processes found."

echo "Stopping any existing VNC server processes..."
pkill -f "Xvnc" || echo "No existing VNC processes found."

vncserver :1 -geometry 680x820 -depth 16

tail -f /dev/null
