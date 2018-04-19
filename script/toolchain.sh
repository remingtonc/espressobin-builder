#!/usr/bin/env bash
echo "Downloading toolchain..."
cd /build/
mkdir -p toolchain
cd toolchain
wget https://releases.linaro.org/components/toolchain/binaries/5.2-2015.11-2/aarch64-linux-gnu/gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu.tar.xz
tar -xvf gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu.tar.xz
export PATH=$PATH:/build/toolchain/gcc-linaro-5.2-2015.11-2-x86_64_aarch64-linux-gnu/bin
echo "Finished extracting toolchain."
