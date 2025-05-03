FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && \
    apt install -y sudo wget curl nano \
    tightvncserver openbox tint2 xterm dbus-x11 x11-xserver-utils xfonts-base \
    openssh-server proxychains4 imagemagick tesseract-ocr tini \
    gnome-keyring libnotify4 libnss3 libxss1 xdg-utils libsecret-1-0 \
    libappindicator3-1 libasound2t64 xautomation && \
    wget -O /tmp/wipter.deb https://github.com/hoainv1807/Docker-Ubuntu-XFCE-XRDP/releases/download/wipter/wipter.deb && \
    apt install -y /tmp/wipter.deb && apt install -f -y && rm /tmp/wipter.deb && \
    mkdir -p /var/run/sshd /root/.vnc /root/.config/openbox && \
    sed -i 's/#Port 22/Port 22222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config && \
    echo "ListenAddress ::" >> /etc/ssh/sshd_config && \
    echo "root:toor" | chpasswd && \
    apt-get autoclean && apt-get autoremove -y && apt-get autopurge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /root/.vnc /root/.config/openbox
RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /root/.config/openbox/rc.xml && \
    echo '<openbox_config>' >> /root/.config/openbox/rc.xml && \
    echo '  <keyboard>' >> /root/.config/openbox/rc.xml && \
    echo '    <keybind key="C-A-T">' >> /root/.config/openbox/rc.xml && \
    echo '      <action name="Execute">' >> /root/.config/openbox/rc.xml && \
    echo '        <command>xterm</command>' >> /root/.config/openbox/rc.xml && \
    echo '      </action>' >> /root/.config/openbox/rc.xml && \
    echo '    </keybind>' >> /root/.config/openbox/rc.xml && \
    echo '  </keyboard>' >> /root/.config/openbox/rc.xml && \
    echo '</openbox_config>' >> /root/.config/openbox/rc.xml

RUN echo '#!/bin/sh' > /root/.vnc/xstartup && \
    echo 'xrdb $HOME/.Xresources' >> /root/.vnc/xstartup && \
    echo 'tint2 & openbox-session &' >> /root/.vnc/xstartup && \
    echo 'sleep 1' >> /root/.vnc/xstartup && \
    echo 'openbox --reconfigure' >> /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup
    
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 5901 22222

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/entrypoint.sh"]
