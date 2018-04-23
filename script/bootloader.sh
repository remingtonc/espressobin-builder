#!/usr/bin/env bash
echo "Acquiring u-boot..."
pushd /build/
mkdir u-boot
cd u-boot
mkdir -p /build/cache/
UBOOT_FILENAME=u-boot-2017.03-armada-17.10.tar.gz
FQ_UBOOT_FILENAME=$CACHE_DIR$UBOOT_FILENAME
if [ -f "${FQ_UBOOT_FILENAME}" ]; then
    echo "Using cached u-boot download."
    cp $FQ_UBOOT_FILENAME $UBOOT_FILENAME
else
    echo "u-boot is not cached, downloading..."
    wget --no-verbose https://github.com/MarvellEmbeddedProcessors/u-boot-marvell/archive/$UBOOT_FILENAME
    echo "Copying u-boot to cache..."
    cp $UBOOT_FILENAME $FQ_UBOOT_FILENAME
fi
echo "Extracting u-boot..."
tar --extract --gzip --file=$UBOOT_FILENAME --strip=1 --check-links
rm $UBOOT_FILENAME
sync
echo "Building u-boot..."
make mvebu_espressobin-88f3720_defconfig
sync
make DEVICE_TREE=armada-3720-espressobin
sync
echo "Exposing desired files..."
mkdir -p /data/u-boot
cp u-boot.bin /data/u-boot/
export BL33=/build/u-boot/u-boot.bin
echo "Done building u-boot."
cd ..
echo "Acquiring atf..."
mkdir atf
cd atf
ATF_FILENAME=atf-v1.3-armada-17.10.tar.gz
FQ_ATF_FILENAME=$CACHE_DIR$ATF_FILENAME
if [ -f "${FQ_ATF_FILENAME}" ]; then
    echo "Using cached atf download..."
    cp $FQ_ATF_FILENAME $ATF_FILENAME
else
    echo "atf is not cached, downloading..."
    git clone -b atf-v1.3-armada-17.10 https://github.com/MarvellEmbeddedProcessors/atf-marvell.git
    tar czf $ATF_FILENAME atf-marvell
    rm -rf atf-marvell
    echo "Copying atf to cache..."
    cp $ATF_FILENAME $FQ_ATF_FILENAME
fi
echo "Extracting atf..."
tar --extract --gzip --file=$ATF_FILENAME --strip=1 --check-links
rm $ATF_FILENAME
sync
cd ..
echo "Acquiring utils..."
mkdir a3700-utils
cd a3700-utils
UTILS_FILENAME=A3700_utils-armada-17.10.tar.gz
FQ_UTILS_FILENAME=$CACHE_DIR$UTILS_FILENAME
if [ -f "${FQ_UTILS_FILENAME}" ]; then
    echo "Using cached utils download."
    cp $FQ_UTILS_FILENAME $UTILS_FILENAME
else
    echo "utils is not cached, downloading..."
    git clone -b A3700_utils-armada-17.10 https://github.com/MarvellEmbeddedProcessors/A3700-utils-marvell.git
    tar czf $UTILS_FILENAME A3700-utils-marvell
    rm -rf A3700-utils-marvell
    echo "Copying utils to cache..."
    cp $UTILS_FILENAME $FQ_UTILS_FILENAME
fi
echo "Extracting utils..."
tar --extract --gzip --file=$UTILS_FILENAME --strip=1 --check-links
rm $UTILS_FILENAME
sync
echo "Acquiring patches..."
wget --no-verbose --content-disposition http://wiki.espressobin.net/tiki-download_file.php?fileId=152
wget --no-verbose --content-disposition http://wiki.espressobin.net/tiki-download_file.php?fileId=151
sync
cd ..
cd atf
echo "Building atf..."
make DEBUG=1 USE_COHERENT_MEM=0 LOG_LEVEL=20 SECURE=0 CLOCKSPRESET=CPU_1000_DDR_800 DDR_TOPOLOGY=2 BOOTDEV=SPINOR PARTNUM=0 WTP=../a3700-utils/ PLAT=a3700 all fip
sync
echo "Exposing desired files..."
mkdir -p /data/atf
cp build/a3700/debug/flash-image.bin /data/atf/
cp -r build/a3700/debug/uart-images /data/atf/
echo "Done building atf."
popd
