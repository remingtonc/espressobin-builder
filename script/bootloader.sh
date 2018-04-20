#!/usr/bin/env bash
pushd /build/
echo "Downloading u-boot..."
mkdir u-boot
cd u-boot
mkdir -p /build/cache/
UBOOT_FILENAME=u-boot-2017.03-armada-17.10.zip
FQ_UBOOT_FILENAME=$CACHE_DIR$UBOOT_FILENAME
if [ -f "${FQ_UBOOT_FILENAME}" ]; then
    cp $FQ_UBOOT_FILENAME $UBOOT_FILENAME
else
    wget --no-verbose https://github.com/MarvellEmbeddedProcessors/u-boot-marvell/archive/$UBOOT_FILENAME
    cp $UBOOT_FILENAME $FQ_UBOOT_FILENAME
fi
unzip $UBOOT_FILENAME
rm $UBOOT_FILENAME
sync
echo "Building u-boot..."
make mvebu_espressobin-88f3720_defconfig
sync
make DEVICE_TREE=armada-3720-espressobin
sync
mkdir -p /data/u-boot
cp u-boot.bin /data/u-boot/
export BL33=/build/u-boot/u-boot.bin
echo "Done building u-boot."
cd ..
echo "Downloading atf..."
mkdir atf
cd atf
ATF_FILENAME=atf-v1.3-armada-17.10.zip
FQ_ATF_FILENAME=$CACHE_DIR$ATF_FILENAME
if [ -f "${FQ_ATF_FILENAME}" ]; then
    cp $FQ_ATF_FILENAME $ATF_FILENAME
else
    wget --no-verbose https://github.com/MarvellEmbeddedProcessors/atf-marvell/archive/$ATF_FILENAME
    cp $ATF_FILENAME $FQ_ATF_FILENAME
fi
unzip $ATF_FILENAME
rm $ATF_FILENAME
sync
cd ..
mkdir a3700-utils
cd a3700-utils
UTILS_FILENAME=A3700_utils-armada-17.10.zip
FQ_UTILS_FILENAME=$CACHE_DIR$UTILS_FILENAME
if [ -f "${FQ_UTILS_FILENAME}" ]; then
    cp $FQ_UTILS_FILENAME $UTILS_FILENAME
else
    wget --no-verbose https://github.com/MarvellEmbeddedProcessors/A3700-utils-marvell/archive/$UTILS_FILENAME
    cp $UTILS_FILENAME $FQ_UTILS_FILENAME
fi
unzip $UTILS_FILENAME
rm $UTILS_FILENAME
sync
wget --content-disposition http://wiki.espressobin.net/tiki-download_file.php?fileId=152
wget --content-disposition http://wiki.espressobin.net/tiki-download_file.php?fileId=151
sync
cd ..
cd atf
echo "Building atf..."
make DEBUG=1 USE_COHERENT_MEM=0 LOG_LEVEL=20 SECURE=0 CLOCKSPRESET=CPU_1000_DDR_800 DDR_TOPOLOGY=2 BOOTDEV=SPINOR PARTNUM=0 WTP=../a3700-utils/ PLAT=a3700 all fip
sync
mkdir -p /data/atf
cp build/a3700/debug/flash-image.bin /data/atf/
cp -r build/a3700/debug/uart-images /data/atf/
echo "Done building atf."
popd
