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
        python3-dev \
        #
        # image i/o packages
        #
        libjpeg-dev \
        libjpeg-dev \
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
        # highgui (imshow) needs these packages
        #
        libgtk2.0-dev \
        libgtk-3-dev \
        #
        # optimize matrix operations by adding these packages
        #
        libatlas-base-dev \
        gfortran

################################################################################
# NOTE ONLY TESTED UP TO HERE: ANYTHING BELOW IS STILL IN TRANSITION
################################################################################

RUN cd /usr/local/src && \
    wget -O opencv.zip \
        "https://github.com/opencv/opencv/archive/${VERSION}.zip" && \
    unzip opencv.zip && \
    rm opencv.zip && \
    wget -O opencv_contrib.zip \
        "https://github.com/opencv/opencv_contrib/archive/${VERSION}.zip" && \
    unzip opencv_contrib.zip && \
    rm opencv_contrib.zip

# build opencv and opencv_contrib

RUN cd "$OPENCV_SRC_DIR/opencv-$VERSION" && mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D WITH_CUDA=OFF \
      -D INSTALL_C_EXAMPLES=ON \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D BUILD_EXAMPLES=ON \
      -D WITH_OPENCL=OFF \
      -D HAVE_OPENCL=ON \
      -D HAVE_OPENCL_STATIC=ON \
    make -j$(nproc) && \
    make install && \
    /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' && \
    ldconfig

# set up python
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py
