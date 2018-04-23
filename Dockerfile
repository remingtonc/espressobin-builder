FROM ubuntu:xenial
# Disable packages attempting to use dialogs during install
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get -qq install apt-utils
# Toolchain, kernel, u-boot
RUN apt-get -qq install sed make binutils build-essential gcc g++ bash patch gzip bzip2 perl tar cpio python unzip rsync zlib1g-dev gawk ccache gettext libssl-dev xsltproc file libncurses5-dev wget git ckermit openssh-server openssh-client
# OpenWRT
RUN apt-get -qq install subversion
# Missing requirements.
# All required during build process.
# bc for kernel, dtc and gcc-arm-linux-gnueabi for bootloader.
RUN apt-get -qq install bc device-tree-compiler gcc-arm-linux-gnueabi
# Reset back to interactive usage
ENV DEBIAN_FRONTEND teletype
COPY script/ /script
COPY config/ /config
WORKDIR /script/
ENTRYPOINT [ "bash" ]
CMD [ "run.sh" ]
