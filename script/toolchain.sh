#!/usr/bin/env bash
echo "Downloading toolchain..."
pushd /build/
mkdir toolchain
cd toolchain
wget --no-verbose https://releases.linaro.org/components/toolchain/binaries/5.2-2015.11-2/aarch64-linux-gnu/gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu.tar.xz
tar --extract --xz --file=gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu.tar.xz
sync
export PATH=$PATH:/build/toolchain/gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu/bin
echo "Finished extracting toolchain."
popd
