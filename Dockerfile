FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y apt-utils \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y sudo \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y qemu-user-static qemu-utils qemu-efi-aarch64 qemu-system-arm
RUN update-binfmts --enable qemu-arm
# ARGUMENTS
# ARG SDK_MANAGER_VERSION=1.2.0-6738
# ARG SDK_MANAGER_VERSION=1.1.0-6343
ARG SDK_MANAGER_VERSION=1.0.1-5538
ARG SDK_MANAGER_DEB=sdkmanager_${SDK_MANAGER_VERSION}_amd64.deb

# add new sudo user
ENV USERNAME jetpack
RUN useradd -m $USERNAME
RUN echo "$USERNAME:$USERNAME" | chpasswd
RUN usermod -aG sudo $USERNAME
RUN usermod -s /bin/bash $USERNAME  

# install package
RUN yes | unminimize && \
    apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        gpg \
        gpg-agent \
        gpgconf \
        gpgv \
        less \
        libcanberra-gtk-module \
        libcanberra-gtk3-module \
        libgconf-2-4 \
        libgtk-3-0 \
        libnss3 \
        libx11-xcb1 \
        libxss1 \
        libxtst6 \
        net-tools \
        python \
        sshpass \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# set locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8



# install SDK Manager
USER jetpack
COPY ${SDK_MANAGER_DEB} /home/${USERNAME}/
WORKDIR /home/${USERNAME}

USER root
RUN echo "${USERNAME}:${USERNAME}" | chpasswd
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN dpkg -i /home/${USERNAME}/${SDK_MANAGER_DEB}
RUN rm /home/${USERNAME}/${SDK_MANAGER_DEB}

USER jetpack