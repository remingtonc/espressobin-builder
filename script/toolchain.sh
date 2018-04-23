#!/usr/bin/env bash
echo "Acquiring toolchain..."
pushd /build/
mkdir toolchain
TOOLCHAIN_FILENAME=gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu.tar.xz
FQ_TOOLCHAIN_FILENAME=$CACHE_DIR$TOOLCHAIN_FILENAME
if [ -f "${FQ_TOOLCHAIN_FILENAME}" ]; then
    echo "Using cached toolchain."
    cp $FQ_TOOLCHAIN_FILENAME $TOOLCHAIN_FILENAME
else
    echo "Toolchain is not cached, downloading..."
    wget --no-verbose https://releases.linaro.org/components/toolchain/binaries/5.2-2015.11-2/aarch64-linux-gnu/$TOOLCHAIN_FILENAME
    echo "Copying toolchain to cache..."
    cp $TOOLCHAIN_FILENAME $FQ_TOOLCHAIN_FILENAME
fi
echo "Extracting toolchain..."
tar --extract --xz --file=$TOOLCHAIN_FILENAME  --strip=1 --check-links
rm $TOOLCHAIN_FILENAME
sync
echo "Setting toolchain build path..."
export PATH=$PATH:/build/toolchain/bin
popd
echo "Done acquiring toolchain."
