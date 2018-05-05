FROM ubuntu:16.04

# See https://www.pyimagesearch.com/2017/09/04/..
#     ..raspbian-stretch-install-opencv-3-python-on-your-raspberry-pi/

# change opencv version here to the one you want installed
ENV OPENCV_VERSION "3.4.1"
# directory where sources of opencv are brought in
ENV OPENCV_SRC_DIR "/usr/local/src/opencv"

# make sure we first have
RUN apt update && apt upgrade && \
    #
    # create opencv sources directory
    #
    RUN mkdir -p "$OPENCV_SRC_DIR" && \
    apt install -y \
        #
        # dev tools packages
        #
        build-essential \
        cmake \
        pkg-config \
        wget \
        curl \
        perl \
        unzip \
        #
        # image i/o packages
        #
        libjpeg8-dev \
        libpng12-dev \
        libtiff5-dev \
        libjasper-dev \
        #
        # video i/o packages
        #
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libv4l-dev \
        libxvidcore-dev \
        libx264-dev \
        #
        # highgui (imshow) needs libgtk packages
        #
        libgtk-3-dev \
        #
        # optimize matrix operations by adding these packages
        #
        libatlas-base-dev \
        gfortran \
        #
        # both pythons setup (2.7 is the default in this OS release)
        # 
        apt install python2.7-dev python3.5-dev

# download opencv

RUN cd "$OPENCV_SRC_DIR" && \
    wget -O opencv.zip \
        "https://github.com/opencv/opencv/archive/${VERSION}.zip" && \
    unzip opencv.zip && \
    wget -O opencv_contrib.zip \
        "https://github.com/opencv/opencv_contrib/archive/${VERSION}.zip" && \
    unzip opencv_contrib.zip

# build opencv and opencv_contrib

RUN cd "$OPENCV_SRC_DIR" && \
    rm opencv.zip && \
    rm opencv_contrib.zip && \
    cd "${OPENCV}-$VERSION" && \
    mkdir build && \
    cd build &&
    cmake -DBUILD_TIFF=ON \
        -D BUILD_opencv_python3=ON
        -D BUILD_opencv_java=OFF \
        -D WITH_CUDA=OFF \
        -D ENABLE_AVX=ON \
        -D WITH_OPENGL=ON \
        -D WITH_OPENCL=ON \
        -D WITH_IPP=ON \
        -D WITH_TBB=ON \
        -D WITH_EIGEN=ON \
        -D WITH_V4L=ON \
        -D BUILD_TESTS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") \
        -D PYTHON_EXECUTABLE=$(which python3.6) \
        -D PYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -D PYTHON_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") .. \
    echo "make" > make.out && \
    make >> make.out 2>&1 && \
    echo "make install" >> make.out && \
    make install >> make.out 2>&1 && \
    /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' && \
    ldconfig && \
    # 
    # set up python
    # 
    wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py
    #
    # get numpy
    #
    pip3 install numpy
