#!/usr/bin/env bash
echo "Downloading kernel..."
pushd /build/
mkdir -p kernel/4.4.8
cd kernel/4.4.8
mkdir -p /build/cache/
wget https://github.com/MarvellEmbeddedProcessors/linux-marvell/archive/linux-4.4.8-armada-17.02-espressobin.zip
unzip linux-4.4.8-armada-17.02-espressobin.zip
mv linux-4.4.8-armada-17.02-espressobin.zip /build/cache/
sync
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
echo "Building kernel..."
make mvebu_v8_lsp_defconfig
sync
make -j$(($(nproc)+1))
sync
echo "Done building kernel."
mkdir -p /data/kernel
cp arch/arm64/boot/Image /data/kernel/
cp arch/arm64/boot/dts/marvell/armada-3720-community.dtb /data/kernel/
popd
