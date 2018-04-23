#!/usr/bin/env bash
echo "Acquiring kernel..."
pushd /build/
mkdir -p kernel/4.4.8
cd kernel/4.4.8
KERNEL_FILENAME=linux-4.4.8-armada-17.02-espressobin.tar.gz
FQ_KERNEL_FILENAME=$CACHE_DIR$KERNEL_FILENAME
if [ -f "${FQ_KERNEL_FILENAME}" ]; then
    echo "Using cached kernel download."
    cp $FQ_KERNEL_FILENAME $KERNEL_FILENAME
else
    echo "Kernel is not cached, downloading..."
    wget --no-verbose https://github.com/MarvellEmbeddedProcessors/linux-marvell/archive/$KERNEL_FILENAME
    echo "Copying kernel to cache..."
    cp -v $KERNEL_FILENAME $FQ_KERNEL_FILENAME
fi
echo "Extracting kernel..."
tar --extract --gzip --file $KERNEL_FILENAME --strip=1 --check-links
rm $KERNEL_FILENAME
sync
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
echo "Building kernel..."
make mvebu_v8_lsp_defconfig
sync
make -j$(($(nproc)+1))
sync
echo "Exposing desired files..."
mkdir -p /data/kernel
cp -v arch/arm64/boot/Image /data/kernel/
cp -v arch/arm64/boot/dts/marvell/armada-3720-community.dtb /data/kernel/
popd
echo "Done acquiring kernel."
