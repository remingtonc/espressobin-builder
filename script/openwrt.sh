#!/usr/bin/env bash
echo "Downloading OpenWRT sources..."
pushd /build/
mkdir -p /build/cache/
OPENWRT_KERNEL_FILENAME=openwrt_17.10_release-kernel.zip
FQ_OPENWRT_KERNEL_FILENAME=$CACHE_DIR$OPENWRT_KERNEL_FILENAME
if [ -f "${FQ_OPENWRT_KERNEL_FILENAME}" ]; then
    cp $FQ_OPENWRT_KERNEL_FILENAME $OPENWRT_KERNEL_FILENAME
else
    wget https://github.com/MarvellEmbeddedProcessors/openwrt-kernel/archive/openwrt_17.10_release.zip
    mv openwrt_17.10_release.zip $OPENWRT_KERNEL_FILENAME
    cp $OPENWRT_KERNEL_FILENAME $FQ_OPENWRT_KERNEL_FILENAME
fi
mkdir openwrt-kernel
unzip $OPENWRT_KERNEL_FILENAME -d openwrt-kernel
rm $OPENWRT_KERNEL_FILENAME
sync
OPENWRT_DD_FILENAME=openwrt_17.10_release-dd.zip
FQ_OPENWRT_DD_FILENAME=$CACHE_DIR$OPENWRT_DD_FILENAME
if [ -f "${FQ_OPENWRT_DD_FILENAME}" ]; then
    cp $FQ_OPENWRT_DD_FILENAME $OPENWRT_DD_FILENAME
else
    wget https://github.com/MarvellEmbeddedProcessors/openwrt-dd/archive/openwrt_17.10_release.zip
    mv openwrt_17.10_release.zip $OPENWRT_DD_FILENAME
    cp $OPENWRT_DD_FILENAME $FQ_OPENWRT_DD_FILENAME
fi
mkdir openwrt-dd
unzip $OPENWRT_DD_FILENAME -d openwrt-dd
rm $OPENWRT_DD_FILENAME
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
