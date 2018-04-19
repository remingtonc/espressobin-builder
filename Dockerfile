FROM debian:latest
# Toolchain, kernel, and u-boot requirements
RUN apt install which sed make binutils build-essential gcc g++ bash patch gzip bzip2 perl tar cpio python unzip rsync zlib1g-dev gawk ccache gettext libssl-dev xsltproc file ncurses5 wget git ckermit openssh-server openssh-client
# OpenWRT requirements
RUN apt install subversion libncurses5-dev
COPY script/ /script
COPY config/ /config
WORKDIR /script/
ENTRYPOINT [ "bash" ]
CMD [ "run.sh" ]
