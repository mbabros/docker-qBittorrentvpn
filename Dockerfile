# qBittorrent and OpenVPN
#
# Version 1.9

FROM ubuntu:18.04
MAINTAINER Andy Ru

VOLUME /downloads
VOLUME /config

ENV DEBIAN_FRONTEND noninteractive

RUN usermod -u 99 nobody

# Update packages and install software
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils openssl \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:qbittorrent-team/qbittorrent-stable \
    && apt-get update \
    && apt-get install -y qbittorrent-nox openvpn curl moreutils net-tools dos2unix kmod iptables ipcalc unrar \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add configuration and scripts
ADD openvpn/ /etc/openvpn/
ADD qbittorrent/ /etc/qbittorrent/

RUN chmod +x /etc/qbittorrent/*.sh /etc/qbittorrent/*.init /etc/openvpn/*.sh

# Expose ports and run
EXPOSE 9091
EXPOSE 8999
EXPOSE 8999/udp
CMD ["mv /usr/sbin/openvpn /usr/sbin/myopenvpn", "sed -i 's/exec openvpn/exec myopenvpn/g' /etc/openvpn/start.sh"]
CMD ["/bin/bash", "/etc/openvpn/start.sh"]
