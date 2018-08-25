#!/usr/bin/env bash
function run_darwin {
    # https://source.android.com/setup/build/initializing#setting-up-a-mac-os-x-build-environment
    if [[ ! -f espressobin_build.dmg || ! -f espressobin_build.dmg.sparseimage ]]; then
        hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 40g ./espressobin_build.dmg
    fi
    hdiutil attach ./espressobin_build.dmg -mountpoint ./build/ \
    || hdiutil attach ./espressobin_build.dmg.sparseimage -mountpoint ./build/
    run_build
    hdiutil detach ./build/
}

function run_build {
    docker run --rm -it \
        --name espressobin-build \
        --mount type=bind,source="$(pwd)"/bin/,target=/data/ \
        --mount type=bind,source="$(pwd)"/build/,target=/build/ \
        --mount type=bind,source="$(pwd)"/cache/,target=/cache/ \
        espressobin/build:latest
}

function clean_build {
    case "${UNAME}" in
        Linux*)     rm -rf build/* && break;;
        Darwin*)    rm espressobin_build.dmg* && break;;
        * ) printf "Uncertain how to clean build!\n" && break;;
    esac
}

while true; do
    read -p "Reset build folders? [Y/N]: " yn
    case $yn in
        [Yy]* ) clean_build;;
        [Nn]* ) break;;
        * ) printf "Please answer [Yy]es or [Nn]o.\n" && break;;
    esac
done

docker build -t espressobin/build .

UNAME="$(uname -s)"
case "${UNAME}" in
    Linux*)     run_build && break;;
    Darwin*)    run_darwin && break;;
    * ) printf "OS currently unsupported!\n" && break;;
esac
