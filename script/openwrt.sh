#!/usr/bin/env bash
pushd /build/
echo "Downloading OpenWRT sources..."
mkdir -p /build/cache/
wget https://github.com/MarvellEmbeddedProcessors/openwrt-kernel/archive/openwrt_17.10_release.zip
mkdir openwrt-kernel
unzip openwrt_17.10_release.zip -d openwrt-kernel
mv openwrt_17.10_release.zip /build/cache/
wget https://github.com/MarvellEmbeddedProcessors/openwrt-dd/archive/openwrt_17.10_release.zip
mkdir openwrt-dd
unzip openwrt_17.10_release.zip -d openwrt-dd
mv openwrt_17.10_release.zip /build/cache/
sync
cd openwrt-dd
./scripts/feeds update -a
./scripts/feeds install -a
echo "LOOK AT SOURCE!!!"
make menuconfig
# Target System --->
#   Marvell 64b Boards
# Target Profile --->
#    ESPRESSObin (Marvell Armada 3700 Community Board)
# Target Images  --->
#    [x] ramdisk  --->
#    * Root filesystem archives *
#    [x] tar.gz
#    * Root filesystem images *
#    [x] ext4  --->
# [x] Advanced configuration options (for developers)  --->
#    (/opt/kernel/openwrt-kernel) Use external kernel tree
echo "Building OpenWRT..."
sync
make -j$(($(nproc)+1))
sync
mkdir -p /data/openwrt/
cp bin/mvebu64/armada-3720-community.dtb /data/openwrt/
cp bin/mvebu64/openwrt-armada-ESPRESSObin-Image /data/openwrt/
cp bin/mvebu64/openwrt-mvebu64-armada-espressobin-rootfs.tar.gz /data/openwrt/
echo "Done building OpenWRT."
popd
