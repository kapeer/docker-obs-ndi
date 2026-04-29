FROM ubuntu:24.04 AS vnc
ARG DEBIAN_FRONTEND="noninteractive"
# for the VNC connection
EXPOSE 5900
# for the browser VNC client
EXPOSE 5901
# for avahi-daemon (mDNS)
EXPOSE 5353
EXPOSE 5959
EXPOSE 6960-6970
EXPOSE 7960-7970
EXPOSE 5960
# for OBS 
EXPOSE 4455
# Fluxbox style customization
ENV FLUXBOX_STYLE=bora_blue
# Make sure the dependencies are met
RUN apt update \
	&& apt install -y tigervnc-standalone-server fluxbox xterm git net-tools python3 python3-numpy python-is-python3 scrot wget curl software-properties-common vlc kmod avahi-daemon sudo ffmpeg dillo \
	&& sed -i 's/geteuid/getppid/' /usr/bin/vlc \
	&& add-apt-repository ppa:obsproject/obs-studio \
	&& git clone --branch v1.0.0 --single-branch https://github.com/novnc/noVNC.git /opt/noVNC \
	&& git clone --branch v0.8.0 --single-branch https://github.com/novnc/websockify.git /opt/noVNC/utils/websockify \
	&& ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Add menu entries to the container
RUN echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"OBS Screencast\" command=\"obs\"" >> /usr/share/menu/custom-docker \
	&& echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"Xterm\" command=\"xterm -ls -bg black -fg white\"" >> /usr/share/menu/custom-docker \
	&& echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"Dillo Browser\" command=\"dillo\"" >> /usr/share/menu/custom-docker && update-menus

# ---------------------------------------------------------

FROM vnc AS obs
# Update apt for the new obs repository
RUN apt update \
	&& mkdir -p /config/obs-studio /root/.config/ \
	&& ln -s /config/obs-studio/ /root/.config/obs-studio \
	# Install obs studio
	&& apt install -y obs-studio

# ---------------------------------------------------------

FROM obs AS obs-ndi

# Download and install DistroAV libraries
RUN wget -q -O /tmp/libndi-get.sh https://raw.githubusercontent.com/DistroAV/DistroAV/refs/heads/master/CI/libndi-get.sh \
	&& chmod +x /tmp/libndi-get.sh \
    && /tmp/libndi-get.sh install
	
# Download and install DistroAV (NDI plugin)
RUN wget -q -O /tmp/distroav.deb https://github.com/DistroAV/DistroAV/releases/download/6.2.1/distroav-6.2.1-x86_64-linux-gnu.deb \
	&& dpkg -i /tmp/distroav.deb
	
# Download and install the plugins for NDI
RUN wget -q -O /tmp/obs-multi-rtmp.deb https://github.com/sorayuki/obs-multi-rtmp/releases/download/0.7.3.2/obs-multi-rtmp-0.7.3.0-x86_64-linux-gnu.deb \
	&& dpkg -i /tmp/obs-multi-rtmp.deb

# Cleanup
RUN apt clean -y \
	&& rm -rf /tmp/*.deb /tmp/*.sh \
	&& rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------
FROM obs-ndi

WORKDIR /opt
# Copy local files
COPY container_startup.sh ./container_startup.sh
COPY x11vnc_entrypoint.sh ./x11vnc_entrypoint.sh
COPY startup.sh ./startup_scripts/startup.sh
RUN chmod -R a+x ./*.sh

VOLUME ["/config"]
ENTRYPOINT ["/opt/container_startup.sh"]
