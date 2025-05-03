FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && \
    apt install -y \
    sudo wget curl nano tightvncserver openbox xterm \
    dbus-x11 x11-xserver-utils xfonts-base \
    openssh-server proxychains4 imagemagick tesseract-ocr tini \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/run/sshd
RUN sed -i 's/#Port 22/Port 22222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config && \
    echo "ListenAddress ::" >> /etc/ssh/sshd_config
RUN echo "root:toor" | chpasswd

RUN mkdir -p /root/.vnc /root/.config/openbox

RUN echo '#!/bin/sh' > /root/.vnc/xstartup && \
    echo 'xrdb $HOME/.Xresources' >> /root/.vnc/xstartup && \
    echo 'openbox-session &' >> /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

EXPOSE 5901 22222

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["/usr/local/bin/entrypoint.sh"]
