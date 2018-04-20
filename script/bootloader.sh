#!/usr/bin/env bash
pushd /build/
echo "Downloading u-boot..."
mkdir u-boot
cd u-boot
mkdir -p /build/cache/
wget https://github.com/MarvellEmbeddedProcessors/u-boot-marvell/archive/u-boot-2017.03-armada-17.10.zip
unzip u-boot-2017.03-armada-17.10.zip
mv u-boot-2017.03-armada-17.10.zip /build/cache/
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
wget https://github.com/MarvellEmbeddedProcessors/atf-marvell/archive/atf-v1.3-armada-17.10.zip
unzip atf-v1.3-armada-17.10.zip
mv atf-v1.3-armada-17.10.zip /build/cache/
sync
cd ..
mkdir a3700-utils
cd a3700-utils
wget https://github.com/MarvellEmbeddedProcessors/A3700-utils-marvell/archive/A3700_utils-armada-17.10.zip
unzip A3700_utils-armada-17.10.zip
mv A3700_utils-armada-17.10.zip /build/cache/
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
