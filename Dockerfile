FROM archlinux:latest

ARG S6_OVERLAY_VERSION=3.1.6.2

RUN pacman -Suy --noconfirm
RUN pacman -S wireguard-tools iptables iproute2 sudo gnu-netcat tailscale --noconfirm

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

COPY ./tailscale /etc/s6-overlay/s6-rc.d/tailscale
RUN echo "" > /etc/s6-overlay/s6-rc.d/user/contents.d/tailscale

COPY ./tailscaled /etc/s6-overlay/s6-rc.d/tailscaled
RUN echo "" > /etc/s6-overlay/s6-rc.d/user/contents.d/tailscaled

ENTRYPOINT ["/init"]
