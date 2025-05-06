FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && \
    apt install -y \
    # ======= Nhóm tiện ích hệ thống =======
    sudo wget curl nano gnupg gdebi dialog htop tini \
    apt-transport-https ca-certificates uuid-runtime \
    util-linux iproute2 net-tools openssh-server xdg-utils \
    # --------------------------------------

    # ======= Nhóm GUI Desktop & Window Manager =======
    tightvncserver openbox tint2 xterm \
    dbus-x11 x11-xserver-utils xfonts-base \
    xautomation gnome-keyring libsecret-1-0 \
    # -----------------------------------------------

    # ======= Nhóm xử lý hình ảnh & OCR =======
    imagemagick tesseract-ocr \
    # ----------------------------------------

    # ======= Nhóm thư viện hệ thống, đồ họa, GUI =======
    libasound2t64 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 \
    libc6 libcairo2 libcups2 libcurl4 libdbus-1-3 libdbus-glib-1-2 \
    libexpat1 libgbm1 libglib2.0-0 libgtk-3-0 libgtk-3-bin libgtk-4-1 \
    libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libudev1 libuuid1 \
    libvulkan1 libgl1 libdrm2 libbsd0 \
    # ---------------------------------------

    # ======= Nhóm thư viện X11 & GUI nâng cao =======
    libx11-6 libx11-xcb1 libxau6 libxcb1 libxcb-glx0 libxcb-icccm4 \
    libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 \
    libxcb-render0 libxcb-shape0 libxcb-shm0 libxcb-sync1 libxcb-util1 \
    libxcb-xfixes0 libxcb-xinerama0 libxcb-xkb1 libxkbcommon0 libxkbcommon-x11-0 \
    libappindicator3-1 libnotify4 libnotify-bin libxcomposite1 libxdamage1 \
    libxext6 libxfixes3 libxrandr2 libxcursor1 libxi6 libxtst6 libxinerama1 \
    libxss1 libxshmfence1 libgdk-pixbuf2.0-0 && \
    # ----------------------------------------------
    wget -O /tmp/wipter.deb https://github.com/hoainv1807/Docker-Ubuntu-XFCE-XRDP/releases/download/wipter/wipter.deb && \
    apt install -y /tmp/wipter.deb && apt install -f -y && rm /tmp/wipter.deb && \
    apt-get -y --fix-broken --no-install-recommends --no-install-suggests install && \
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
    echo '    <keybind key="F1">' >> /root/.config/openbox/rc.xml && \
    echo '      <action name="MaximizeFull"/>' >> /root/.config/openbox/rc.xml && \
    echo '    </keybind>' >> /root/.config/openbox/rc.xml && \
    echo '    <keybind key="F2">' >> /root/.config/openbox/rc.xml && \
    echo '      <action name="Iconify"/>' >> /root/.config/openbox/rc.xml && \
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
