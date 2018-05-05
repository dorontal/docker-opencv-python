#!/bin/bash

# build_image.sh - run this in same directory as Dockerfile

docker build -t opencv-python . > build.out 2>&1
