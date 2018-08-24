#!/usr/bin/env bash
echo "Acquiring OpenWRT..."
pushd /build/
mkdir -p /build/cache/
OPENWRT_ARCHIVE_FILENAME=openwrt_17.10_release.tar.gz
OPENWRT_KERNEL_FILENAME=openwrt_17.10_release-kernel.tar.gz
FQ_OPENWRT_KERNEL_FILENAME=$CACHE_DIR$OPENWRT_KERNEL_FILENAME
if [ -f "${FQ_OPENWRT_KERNEL_FILENAME}" ]; then
    echo "Using cached OpenWRT kernel..."
    cp $FQ_OPENWRT_KERNEL_FILENAME $OPENWRT_KERNEL_FILENAME
else
    echo "OpenWRT kernel is not cached, downloading..."
    wget --no-verbose https://github.com/MarvellEmbeddedProcessors/openwrt-kernel/archive/$OPENWRT_ARCHIVE_FILENAME
    mv $OPENWRT_ARCHIVE_FILENAME $OPENWRT_KERNEL_FILENAME
    echo "Copying OpenWRT kernel to cache..."
    cp -v $OPENWRT_KERNEL_FILENAME $FQ_OPENWRT_KERNEL_FILENAME
fi
mkdir openwrt-kernel
echo "Extracting OpenWRT kernel..."
tar --extract --gzip --file=$OPENWRT_KERNEL_FILENAME --directory=openwrt-kernel --strip=1 --check-links
rm $OPENWRT_KERNEL_FILENAME
sync
OPENWRT_DD_FILENAME=openwrt_17.10_release-dd.tar.gz
FQ_OPENWRT_DD_FILENAME=$CACHE_DIR$OPENWRT_DD_FILENAME
if [ -f "${FQ_OPENWRT_DD_FILENAME}" ]; then
    echo "Using cached OpenWRT DD."
    cp $FQ_OPENWRT_DD_FILENAME $OPENWRT_DD_FILENAME
else
    echo "OpenWRT DD is not cached, downloading..."
    wget --no-verbose https://github.com/MarvellEmbeddedProcessors/openwrt-dd/archive/$OPENWRT_ARCHIVE_FILENAME
    mv $OPENWRT_ARCHIVE_FILENAME $OPENWRT_DD_FILENAME
    echo "Copying OpenWRT DD to cache..."
    cp -v $OPENWRT_DD_FILENAME $FQ_OPENWRT_DD_FILENAME
fi
mkdir openwrt-dd
echo "Extracting OpenWRT DD..."
tar --extract --gzip --file=$OPENWRT_DD_FILENAME --directory=openwrt-dd --strip=1 --check-links
rm $OPENWRT_DD_FILENAME
sync
cd openwrt-dd
echo "Running OpenWRT DD scripts..."
./scripts/feeds update -a
./scripts/feeds install -a
echo "Using preconfigured .config..."
cp /config/openwrt.config .config 
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
#    (/build/openwrt-kernel) Use external kernel tree
echo "Building OpenWRT..."
# Force/enable build as root
export FORCE_UNSAFE_CONFIGURE=1
# Fix yaffs2 compilation
# Thank you https://forum.openwrt.org/t/lede-compile-fail-mkyaffs-problem/203/2
# Due to downloading tar instead of from git
date +%s > version.date
#make -j1 V=s
make -j$(($(nproc)+1))
sync
echo "Exposing desired files..."
mkdir -p /data/openwrt/
cp -v bin/mvebu64/armada-3720-community.dtb /data/openwrt/
cp -v bin/mvebu64/openwrt-armada-ESPRESSObin-Image /data/openwrt/
cp -v bin/mvebu64/openwrt-mvebu64-armada-espressobin-rootfs.tar.gz /data/openwrt/
popd
echo "Done acquiring OpenWRT."
