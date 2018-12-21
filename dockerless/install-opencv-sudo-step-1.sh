#!/bin/bash

# NOTES:
# * Run this as sudo.

apt-get update && apt-get upgrade

apt-get install -y --no-install-recommends \
        apt-utils \
        build-essential \
        ccache \
        cmake \
        curl \
        doxygen \
        emacs \
        ffmpeg \
        gfortran \
        git \
        ipython3 \
        libatlas-base-dev \
        libatlas3-base \
        libavcodec-dev \
        libavformat-dev \
        libavresample-dev \
        libcanberra-gtk* \
        libdc1394-22-dev \
        libeigen3-dev \
        libgdal-dev \
        libgphoto2-dev \
        libgstreamer-plugins-base1.0-dev \
	libgtk-3-dev \
        libjasper-dev \
        libjpeg-dev \
        liblapacke-dev \
        libopencore-amrnb-dev \
        libopencore-amrwb-dev \
        libopenexr-dev \
        libpng-dev \
        libqt4-dev \
        libqt4-opengl-dev \
        libswscale-dev \
        libtbb-dev \
        libtheora-dev \
        libtiff5-dev \
        libv4l-0 \
        libv4l-dev \
        libvorbis-dev \
        libvtk6-dev \
        libwebp-dev \
        libx264-dev \
        libxine2-dev \
        libxvidcore-dev \
        net-tools \
        perl \
        pkg-config \
        python3-dev \
        sphinx-common \
        texlive-latex-extra \
        unzip \
        v4l-utils \
        wget \
        yasm \
        zlib1g-dev

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
cp $MYDIR/sobelfilterwidget.cpp \
   $MYDIR/opencv_contrib/modules/cvv/src/qtutil/filter/sobelfilterwidget.cpp

# create build directory

cd opencv
mkdir build
cd build

# -D WITH_IPP=ON \

PYTHON_EXECUTABLE="$HOME/.virtualenvs/cv/bin/python3"
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
   -D WITH_QT=ON \
   -D WITH_OPENGL=OFF \
   -D FORCE_VTK=ON \
   -D WITH_TBB=ON \
   -D WITH_GDAL=ON \
   -D WITH_XINE=ON \
   -D ENABLE_PRECOMPILED_HEADERS=OFF \
   -D OPENCV_EXTRA_MODULES_PATH="$MYDIR/opencv_contrib/modules" \
   -D WITH_V4L=ON \
   -D WITH_LIBV4L=ON \
   -D WITH_OPENCL=ON \
   -D WITH_EIGEN=ON \
   -D WITH_CUDA=OFF \
   -D BUILD_opencv_java=OFF \
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
