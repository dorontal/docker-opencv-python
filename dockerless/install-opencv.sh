#!/bin/bash

CV_VERSION='4.0.0'

################### setting up a virtual environment ###########################
# sudo apt install python3-virtualenv
# mkdir ~/env
# cd ~/env
# python3 -m virtualenv cv -p /usr/bin/python3
# source ./cv/bin/activate
# pip install numpy
# pip install matplotlib
# mkdir ./cv/src
################################################################################

# NOTES:
# 1) do not run this as sudo!
# 2) cv virtualenv (see comment above) must be activated

cd ~/env/cv/src
echo "Installing opencv in directory: `pwd`"

# download opencv

GITPREFIX="https://github.com/opencv/"
wget "$GITPREFIX/opencv/archive/$CV_VERSION.zip"
unzip "$CV_VERSION.zip"
rm "$CV_VERSION.zip"
mv "opencv-$CV_VERSION" opencv

wget "$GITPREFIX/opencv_contrib/archive/$CV_VERSION.zip"
unzip "$CV_VERSION.zip"
rm "$CV_VERSION.zip"
mv "opencv_contrib-$CV_VERSION" opencv_contrib

# apply patch
# MYDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# cp $MYDIR/sobelfilterwidget.cpp \
#    $MYDIR/opencv_contrib/modules/cvv/src/qtutil/filter/sobelfilterwidget.cpp

# create build directory

cd opencv
mkdir build
cd build

PYTHON_LIBRARY="/usr/lib/arm-linux-gnueabihf/libpython3.5m.so"
PYTHON_INCLUDE_DIR="/usr/include/python3.5m/"
PYTHON_INCLUDE_DIR2="/usr/include/arm-linux-gnueabihf/python3.5m/"
PYTHON_NUMPY_INCLUDE_DIRS="/usr/lib/python3/dist-packages/numpy/core/include/"

cmake \
   -D CMAKE_BUILD_TYPE=RELEASE \
   -D CMAKE_INSTALL_PREFIX=/usr/local \
   -D ENABLE_NEON=ON \
   -D ENABLE_VFPV3=ON \
   -D BUILD_TESTS=OFF \
   -D BUILD_EXAMPLES=OFF \
   -D OPENCV_ENABLE_NONFREE=ON \
   -D INSTALL_PYTHON_EXAMPLES=OFF \
   -D INSTALL_C_EXAMPLES=OFF \
   -D WITH_FFMPEG=ON \
   -D WITH_QT=OFF \
   -D WITH_OPENGL=OFF \
   -D FORCE_VTK=ON \
   -D WITH_TBB=ON \
   -D WITH_GDAL=ON \
   -D WITH_XINE=ON \
   -D ENABLE_PRECOMPILED_HEADERS=OFF \
   -D OPENCV_EXTRA_MODULES_PATH="../../opencv_contrib/modules" \
   -D WITH_V4L=ON \
   -D WITH_LIBV4L=ON \
   -D WITH_OPENCL=ON \
   -D WITH_EIGEN=ON \
   -D WITH_CUDA=OFF \
   -D BUILD_opencv_java=OFF \
   -D PYTHON_LIBRARY="$PYTHON_LIBRARY" \
   -D PYTHON_INCLUDE_DIR="$PYTHON_INCLUDE_DIR" \
   -D PYTHON_INCLUDE_DIR2="$PYTHON_INCLUDE_DIR2" \
   -D PYTHON_NUMPY_INCLUDE_DIRS="$PYTHON_NUMPY_INCLUDE_DIRS" \
   ..

make -j4

# next, execute these commands as root:
#
# sudo make install
# sudo ldconfig

# next, execute these commands as non-root:
#
# cd ~/env/cv/lib/python3.5/site-packages
# ln -s /usr/local/python/cv2 .
