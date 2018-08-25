#!/usr/bin/env bash
function run_darwin {
    # https://source.android.com/setup/build/initializing#setting-up-a-mac-os-x-build-environment
    # APFS volumes are wayyyyy faster than sparse disks
    # https://www.dssw.co.uk/reference/diskutil.html
    APFS_CONTAINER=$(diskutil apfs list | grep 'APFS Container Reference' | head -n 1 | awk '{print $4}')
    APFS_DISK=$(sudo diskutil apfs addVolume $APFS_CONTAINER 'Case-sensitive APFS' espressobin_build -reserve 25g -quota 40g -mountpoint $(pwd)/build/ | grep 'New APFS disk' | awk '{print $4}')
    run_build
    sudo diskutil apfs deleteVolume $APFS_DISK
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
            printf "Cleaned implicitly.\n"
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
