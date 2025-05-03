FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && \
    apt install -y sudo wget curl nano \
    tightvncserver openbox xterm dbus-x11 x11-xserver-utils xfonts-base \
    openssh-server proxychains4 imagemagick tesseract-ocr tini \
    libnotify4 libnss3 libxss1 xdg-utils libsecret-1-0 \
    libappindicator3-1 libasound2t64 xautomation && \
    wget -O /tmp/wipter.deb https://github.com/hoainv1807/Docker-Ubuntu-XFCE-XRDP/releases/download/wipter/wipter.deb && \
    apt install -y /tmp/wipter.deb && apt install -f -y && rm /tmp/wipter.deb && \
    mkdir -p /var/run/sshd /root/.vnc /root/.config/openbox && \
    sed -i 's/#Port 22/Port 22222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config && \
    echo "ListenAddress ::" >> /etc/ssh/sshd_config && \
    echo "root:toor" | chpasswd && \
    echo '#!/bin/sh\nxrdb $HOME/.Xresources\nopenbox-session &' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup && \
    apt-get autoclean && apt-get autoremove -y && apt-get autopurge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 5901 22222

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/entrypoint.sh"]
