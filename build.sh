#!/usr/bin/env bash
docker build -t espressobin/build .
docker run -v ./bin:/data/:rw -v ./build:/build/:rw --device /dev/usbtty0 espressobin/build:latest
