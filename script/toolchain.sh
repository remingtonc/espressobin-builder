#!/usr/bin/env bash
echo "Downloading toolchain..."
pushd /build/
mkdir toolchain
TOOLCHAIN_FILENAME=gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu.tar.xz
FQ_TOOLCHAIN_FILENAME=$CACHE_DIR$TOOLCHAIN_FILENAME
if [ -f "${FQ_TOOLCHAIN_FILENAME}" ]; then
    cp $FQ_TOOLCHAIN_FILENAME .
else
    wget --no-verbose https://releases.linaro.org/components/toolchain/binaries/5.2-2015.11-2/aarch64-linux-gnu/gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu.tar.xz
    cp $TOOLCHAIN_FILENAME $FQ_TOOLCHAIN_FILENAME
fi
tar --extract --xz --file=gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu.tar.xz
rm $TOOLCHAIN_FILENAME
sync
export PATH=$PATH:/build/toolchain/gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu/bin
echo "Finished extracting toolchain."
popd
