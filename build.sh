#!/usr/bin/env bash
function run_darwin {
    # https://source.android.com/setup/build/initializing#setting-up-a-mac-os-x-build-environment
    if [[ ! -f espressobin_build.dmg || ! -f espressobin_build.dmg.sparseimage ]]; then
        hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 40g ./espressobin_build.dmg
    fi
    hdiutil attach ./espressobin_build.dmg.sparseimage -mountpoint ./build/ \
    || hdiutil attach ./espressobin_build.dmg -mountpoint ./build/
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
    case "$(uname -s)" in
        Linux*)
            rm -rf build/*
            ;;
        Darwin*)
            rm espressobin_build.dmg*
            ;;
        * )
            printf "Uncertain how to clean build!\n"
            ;;
    esac
}

while true; do
    read -p "Reset build folders? [Y/N]: " yn
    case $yn in
        [Yy]* )
            clean_build
            break
            ;;
        [Nn]* )
            break
            ;;
        * )
            printf "Please answer [Yy]es or [Nn]o.\n"
            ;;
    esac
done

docker build -t espressobin/build .

case "$(uname -s)" in
    Linux*)
        run_build
        ;;
    Darwin*)
        run_darwin
        ;;
    * )
        printf "OS currently unsupported!\n"
        ;;
esac
