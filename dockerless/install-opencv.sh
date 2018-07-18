#!/bin/bash

# NOTES:
# * See 'http://milq.github.io/install-opencv-ubuntu-debian'.
# * Video won't work, unless you follow instructions by yinguobing
#   to first install ffmpeg, see: 
#       https://github.com/opencv/opencv/issues/9794

CV_VERSION='3.4.2'
MYDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

apt-get install -y --no-install-recommends \
	qt5-default \
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
        libcanberra-gtk-dev \
	libdc1394-22-dev \
        libeigen3-dev \
        libgphoto2-dev \
        libgstreamer-plugins-base1.0-dev \
        libgtk2.0-dev \
        # libjasper-dev \
        libjpeg-dev \
        liblapacke-dev \
        libopencore-amrnb-dev \
        libopencore-amrwb-dev \
	libvtk6-dev \
	libwebp-dev \
	libpng-dev \
	libtiff5-dev \
	libopenexr-dev \
	libgdal-dev \
        libqt4-dev \
        libqt4-opengl-dev \
        libswscale-dev \
        libtbb-dev \
        libtheora-dev \
        libv4l-0 \
        libv4l-dev \
        libvorbis-dev \
        libx264-dev \
	libxine2-dev \
        libxvidcore-dev \
        net-tools \
        perl \
        pkg-config \
	python3-dev \
        python3-matplotlib \
        python3-numpy \
        python3-pandas \
        python3-scipy \
        python3-tk \
        python3.5-dev \
        sphinx-common \
        texlive-latex-extra \
        v4l-utils \
	unzip \
        wget \
	yasm \
	zlib1g-dev


# download opencv

GITPREFIX="https://github.com/opencv/"
wget "$GITPREFIX/opencv/archive/$CV_VERSION.zip"
unzip "$CV_VERSION.zip"
rm "$CV_VERSION.zip"

wget "$GITPREFIX/opencv_contrib/archive/$CV_VERSION.zip"
unzip "$CV_VERSION.zip"
rm "$CV_VERSION.zip"

cd "opencv-$CV_VERSION"
mkdir build
cd build

cmake \
    -D WITH_FFMPEG=ON \
    -D WITH_QT=ON \
    -D WITH_OPENGL=ON \
    -D FORCE_VTK=ON \
    -D WITH_TBB=ON \
    -D WITH_GDAL=ON \
    -D WITH_XINE=ON \
    -D BUILD_EXAMPLES=ON \
    -D ENABLE_PRECOMPILED_HEADERS=OFF \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH="$MYDIR/opencv_contrib-$CV_VERSION/modules" \
    -D BUILD_EXAMPLES=ON \
    -D WITH_TBB=ON \
    -D WITH_V4L=ON \
    -D WITH_LIBV4L=ON \
    -D WITH_IPP=ON \
    -D WITH_OPENCL=ON \
    -D WITH_OPENGL=ON \
    -D WITH_EIGEN=ON \
    -D WITH_CUDA=OFF \
    -D INSTALL_C_EXAMPLES=ON \
    -D PYTHON_EXECUTABLE=/usr/bin/python3 \
    -D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.5m.so \
    -D PYTHON_INCLUDE_DIR=/usr/include/python3.5m/ \
    -D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python3.5m/ \
    -D PYTHON_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include/ \
    -D BUILD_opencv_java=OFF \
    ..

make -j4
sudo make install
sudo ldconfig
