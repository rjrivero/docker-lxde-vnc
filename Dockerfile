FROM phusion/baseimage

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install vnc4server (supports xrandr) and lxde
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git vnc4server lxde && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Clone noVNC, and set vnc_auto as homepage
RUN git clone --recursive https://github.com/kanaka/noVNC.git /opt/novnc && \
    git clone --recursive https://github.com/kanaka/websockify.git /opt/novnc/utils/websockify && \
    mv /opt/novnc/vnc_auto.html /opt/novnc/index.html

# Add vnc user and group, with id 1000
RUN groupadd -g 1000 vnc && \
    useradd -m -d /home/vnc -s /bin/bash -u 1000 -g vnc vnc && \
    mkdir /home/vnc/.vnc && \
    chown -R vnc:vnc /opt/novnc

# Add vnc4server and novnc services
ADD files/service     /etc/service
ADD files/my_init.d   /etc/my_init.d

# Enable rotation of VNC logs
ADD files/logrotate.d /etc/logrotate.d

# Requested geometries, in a colon-separated list.
ENV GEOMETRY 800x600:1920x1080:1920x920:1280x800:1280x720:1024x768

# Data volume
VOLUME /home/vnc/Documents

# noVNC port
EXPOSE 6080

# Add xstartup file to launch lxde
ADD files/xstartup /home/vnc/.vnc/xstartup
