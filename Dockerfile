FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    x11vnc \
    xvfb \
    novnc \
    websockify \
    dbus-x11 \
    sudo \
    curl \
    wget \
    git \
    vim \
    nano \
    net-tools \
    iputils-ping \
    dnsutils \
    netcat-openbsd \
    procps \
    htop \
    unzip \
    zip \
    tree \
    jq \
    python3 \
    python3-pip \
    ca-certificates \
    openjdk-21-jdk \
    maven \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash labuser && \
    echo "labuser:lab123" | chpasswd && \
    usermod -aG sudo labuser

RUN echo "labuser ALL=(ALL) NOPASSWD:ALL" \
    > /etc/sudoers.d/labuser && \
    chmod 440 /etc/sudoers.d/labuser

COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
