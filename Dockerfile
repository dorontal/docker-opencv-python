FROM ubuntu:16.04

# change opencv version here to the one you want installed
ENV OPENCV_VERSION "3.4.1"
# directory where sources of opencv are brought in
ENV OPENCV_SRC_DIR "/usr/local/src/opencv"

# make sure we first have
RUN apt update && apt upgrade && \
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
        libgphoto2-dev \
        #
        # video i/o packages
        #
        libavcodec-dev \
        libavformat-dev \
        libavresample-dev \
        libswscale-dev \
        libv4l-dev \
        libxvidcore-dev \
        libx264-dev \
        #
        # saw complaints about these not available during opencv
        # compile so including them just in case their absence
        # breaks something
        #
        libdc1394-22-dev \
        libgstreamer0.10-0 \
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
        # get python
        #
        python3-dev

# download opencv

RUN mkdir -p "$OPENCV_SRC_DIR" && \
    cd "$OPENCV_SRC_DIR" && \
    wget -O opencv.zip \
        "https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip" && \
    unzip opencv.zip && \
    wget -O opencv_contrib.zip \
        "https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip" && \
    unzip opencv_contrib.zip

# build opencv and opencv_contrib

RUN cd "$OPENCV_SRC_DIR/opencv-$OPENCV_VERSION" && \
    # rm opencv.zip && \
    # rm opencv_contrib.zip && \
    mkdir build && \
    cd build && \
    cmake -DBUILD_TIFF=On \
        -D BUILD_opencv_python3=On \
        -D BUILD_opencv_java=Off \
        -D WITH_CUDA=Off \
        -D ENABLE_AVX=On \
        -D WITH_OPENGL=On \
        -D WITH_OPENCL=On \
        -D WITH_IPP=On \
        -D WITH_TBB=On \
        -D WITH_EIGEN=On \
        -D WITH_V4L=On \
        -D BUILD_TESTS=Off \
        -D BUILD_PERF_TESTS=Off \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D PYTHON_EXECUTABLE=python3 \
        -D PYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -D PYTHON_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") .. && \
    make && \
    make install && \
    /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' && \
    ldconfig && \
    #
    # set up python
    #
    wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    #
    # get numpy
    #
    pip3 install numpy
