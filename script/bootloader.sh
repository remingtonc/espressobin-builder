#!/usr/bin/env bash
cd /build/
echo "Downloading u-boot..."
mkdir u-boot
cd u-boot
git clone -b u-boot-2017.03-armada-17.10 https://github.com/MarvellEmbeddedProcessors/u-boot-marvell .
echo "Building u-boot..."
make mvebu_espressobin-88f3720_defconfig
make DEVICE_TREE=armada-3720-espressobin
mkdir -p /data/u-boot
cp u-boot.bin /data/u-boot/
export BL33=/build/u-boot/u-boot.bin
echo "Done building u-boot."
cd ..
echo "Downloading atf..."
mkdir atf
cd atf
git clone -b atf-v1.3-armada-17.10 https://github.com/MarvellEmbeddedProcessors/atf-marvell.git .
cd ..
mkdir a3700-utils
cd a3700-utils
git clone -b A3700_utils-armada-17.10 https://github.com/MarvellEmbeddedProcessors/A3700-utils-marvell.git .
wget http://wiki.espressobin.net/tiki-download_file.php?fileId=152
wget http://wiki.espressobin.net/tiki-download_file.php?fileId=151
cd ..
cd atf
echo "Building atf..."
make DEBUG=1 USE_COHERENT_MEM=0 LOG_LEVEL=20 SECURE=0 CLOCKSPRESET=CPU_1000_DDR_800 DDR_TOPOLOGY=2 BOOTDEV=SPINOR PARTNUM=0 WTP=../a3700-utils/ PLAT=a3700 all fip
mkdir -p /data/atf
cp uild/a3700/debug/flash-image.bin /data/atf/
cp -r build/a3700/debug/uart-images /data/atf/
echo "Done building atf."
