#!/usr/bin/env bash
function run_darwin {
    # https://source.android.com/setup/build/initializing#setting-up-a-mac-os-x-build-environment
    hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 40g ./espressobin_build.dmg
    hdiutil attach ./espressobin_build.dmg -mountpoint ./build/ \
    || hdiutil attach ./espressobin_build.dmg.sparseimage -mountpoint ./build/
    run_build
    hdiutil detach ./build/
    rm ./espressobin_build.dmg \
    || rm ./espressobin_build.dmg.sparseimage
}

function run_build {
    docker run --rm -it \
        --name espressobin-build \
        --mount type=bind,source="$(pwd)"/bin/,target=/data/ \
        --mount type=bind,source="$(pwd)"/build/,target=/build/ \
        --mount type=bind,source="$(pwd)"/cache/,target=/cache/ \
        espressobin/build:latest
}

while true; do
    read -p "Reset build folders? [Y/N]: " yn
    case $yn in
        [Yy]* ) rm -rf build/* && break;;
        [Nn]* ) exit 0;;
        * ) printf "Please answer [Yy]es or [Nn]o.\n";;
    esac
done
docker build -t espressobin/build .
UNAME="$(uname -s)"
case "${UNAME}" in
    Linux*)     run_build;;
    Darwin*)    run_darwin;;
esac
