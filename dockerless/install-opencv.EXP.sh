#!/bin/bash

cd opencv
# mkdir build
cd build

PYTHON_EXECUTABLE="$HOME/.virtualenvs/cv/bin/python"
PYTHON_LIBRARY="/usr/lib/arm-linux-gnueabihf/libpython3.5m.so.1"
PYTHON_INCLUDE_DIR="/usr/include/python3.5m/"
PYTHON_INCLUDE_DIR2="/usr/include/arm-linux-gnueabihf/python3.5m/"
PYTHON_NUMPY_INCLUDE_DIRS="/usr/lib/python3/dist-packages/numpy/core/include/"

cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
  -D ENABLE_NEON=ON \
  -D ENABLE_VFPV3=ON \
  -D BUILD_TESTS=OFF \
  -D OPENCV_ENABLE_NONFREE=ON \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D BUILD_EXAMPLES=OFF \
  -D PYTHON_EXECUTABLE="$PYTHON_EXECUTABLE" \
  -D PYTHON_LIBRARY="$PYTHON_LIBRARY" \
  -D PYTHON_INCLUDE_DIR="$PYTHON_INCLUDE_DIR" \
  -D PYTHON_INCLUDE_DIR2="$PYTHON_INCLUDE_DIR2" \
  -D PYTHON_NUMPY_INCLUDE_DIRS="$PYTHON_NUMPY_INCLUDE_DIRS" \
  ..

exit 0
make -j4
make install
ldconfig
