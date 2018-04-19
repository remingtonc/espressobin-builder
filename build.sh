#!/usr/bin/env bash
while true; do
    read -p "Reset build folders? [Y/N]: " yn
    case $yn in
        [Yy]* ) rm -rf build/* && rm -rf bin/* && break;;
        [Nn]* ) exit 0;;
        * ) printf "Please answer [Yy]es or [Nn]o.\n";;
    esac
done
docker build -t espressobin/build .
docker run -it \
    --name espressobin-build \
    --mount type=bind,source="$(pwd)"/bin/,target=/data/ \
    --mount type=bind,source="$(pwd)"/build/,target=/build/ \
    espressobin/build:latest
