FROM ubuntu:18.04

LABEL description="Environment for PetaLinux 2019.2 development"
LABEL version="1.0"
LABEL maintainer="Carsten.Hansen@hbkworld.com"

# Set up time zone to avoid questions when installing packages
ARG TIME_ZONE=GMT
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && \
    echo $TIME_ZONE > /etc/timezone

# Need i386 for zlib1g required by PetaLinux
RUN dpkg --add-architecture i386

RUN apt-get update --fix-missing

RUN apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    build-essential \
    chrpath \
    cpio \
    debianutils \
    diffstat \
    expect \
    flex \
    gawk \
    g++ \
    gcc \
    gcc-multilib \
    git \
    gnupg \
    iproute2 \
    iputils-ping \
    less \
    libegl1-mesa \
    libncurses5-dev \
    libsdl1.2-dev \
    libselinux1 \
    libssl-dev \
    libtool \
    net-tools \
    pax \
    pylint3 \
    python \
    python3 \
    python3-git \
    python3-jinja2 \
    python3-pexpect \
    python3-pip \
    rsync \
    screen \
    socat \
    sudo \
    texinfo \
    unzip \
    wget \
    xterm \
    xz-utils \
    zlib1g-dev \
    zlib1g:i386

# Change shell from dash to bash
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure -f noninteractive dash

# Set locale to UTF-8
ARG MY_LOC=en_US.UTF-8
RUN apt-get install -y --no-install-recommends locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=$MY_LOC LANG=$MY_LOC
ENV LC_ALL=$MY_LOC
ENV LANG=$MY_LOC

# Add local user with sudo privileges, mapping uid/gid to host so files can be accessed from outside
ARG USER_NAME=build
ARG HOST_UID=1001
ARG HOST_GID=1001
RUN groupadd -g $HOST_GID $USER_NAME && \
    useradd -g $HOST_GID -m -s /bin/bash -u $HOST_UID $USER_NAME && \
    usermod -aG sudo $USER_NAME

# Require no password for sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# While root, prepare installation folder for PetaLinux
RUN mkdir -p /opt/pkg && \
    chown $USER_NAME /opt/pkg

# Switch to user $USER_NAME in the home directory
USER $USER_NAME
WORKDIR /home/$USER_NAME

# Install PetaLinux
ARG PETALINUX_INSTALLER=petalinux-v2019.2-final-installer.run
COPY --chown=$USER_NAME:$USER_NAME accept-eula.sh /home/$USER_NAME
COPY --chown=$USER_NAME:$USER_NAME ${PETALINUX_INSTALLER} /home/$USER_NAME
RUN chmod +x /home/$USER_NAME/accept-eula.sh && \
    chmod +x /home/$USER_NAME/${PETALINUX_INSTALLER} && \
    /home/$USER_NAME/accept-eula.sh /home/$USER_NAME/${PETALINUX_INSTALLER} /opt/pkg/petalinux && \
    rm accept-eula.sh ${PETALINUX_INSTALLER}
