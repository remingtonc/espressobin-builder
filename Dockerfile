FROM ubuntu:xenial
# Disable packages attempting to use dialogs during install
ENV DEBIAN_FRONTEND noninteractive
# Toolchain, kernel, u-boot, and OpenWRT requirements (and missing)
RUN apt-get -qq update \
    && apt-get -qq install apt-utils \
    && apt-get -qq install sed make binutils build-essential gcc g++ bash patch gzip bzip2 perl tar cpio python unzip rsync zlib1g-dev gawk ccache gettext libssl-dev xsltproc file libncurses5-dev wget git ckermit openssh-server openssh-client \
    && apt-get -qq install subversion \
    && apt-get -qq install bc
# Reset back to interactive usage
ENV DEBIAN_FRONTEND teletype
COPY script/ /script
COPY config/ /config
WORKDIR /script/
ENTRYPOINT [ "bash" ]
CMD [ "run.sh" ]
