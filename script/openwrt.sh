#!/usr/bin/env bash
pushd /build/
echo "Downloading OpenWRT sources..."
git clone -b openwrt_17.10_release https://github.com/MarvellEmbeddedProcessors/openwrt-kernel.git
sync
git clone -b openwrt_17.10_release https://github.com/MarvellEmbeddedProcessors/openwrt-dd.git
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
