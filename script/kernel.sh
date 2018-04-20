#!/usr/bin/env bash
echo "Downloading kernel..."
pushd /build/
mkdir -p kernel/4.4.8
cd kernel/4.4.8
mkdir -p /build/cache/
KERNEL_FILENAME=linux-4.4.8-armada-17.02-espressobin.zip
FQ_KERNEL_FILENAME=$CACHE_DIR$KERNEL_FILENAME
if [ -f "${FQ_KERNEL_FILENAME}" ]; then
    cp $FQ_KERNEL_FILENAME $KERNEL_FILENAME
else
    wget --no-verbose https://github.com/MarvellEmbeddedProcessors/linux-marvell/archive/$KERNEL_FILENAME
    cp $KERNEL_FILENAME FQ_KERNEL_FILENAME
fi
unzip $KERNEL_FILENAME
rm $KERNEL_FILENAME
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
