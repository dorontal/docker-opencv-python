FROM debian:jessie

# change opencv version here to the one you want installed
ENV OPENCV_VERSION "3.4.1"
# directory where sources of opencv are brought in
ENV OPENCV_SRC_DIR "/usr/local/src/opencv"
# opencv source directory urls
ENV OPENCV_SRC_URL "https://github.com/opencv/opencv/archive"
ENV OPENCV_CONTRIB_URL "https://github.com/opencv/opencv_contrib/archive"

# make sure we first have
# liblapack-dev \
# liblapack3-dev \
# libopenblas-dev \
RUN apt-get update && apt-get install apt-utils -y && apt-get upgrade -y
RUN apt-get install -y \
        build-essential \
        ccache \
        cmake \
        curl \
        gfortran \
        git \
        guvcview \
        ipython3 \
        ipython3-notebook \
        libatlas-base-dev \
        libatlas3-base \
        libavcodec-dev \
        libavformat-dev \
        libavresample-dev \
        libcanberra-gtk-dev \
        libeigen3-dev \
        libgphoto2-dev \
        libgstreamer-plugins-base1.0-dev \
        libgtk2.0-dev \
        libjasper-dev \
        libjpeg-dev \
        liblapacke-dev \
        libopencore-amrnb-dev \
        libopencore-amrwb-dev \
        libpng12-dev \
        libqt4-dev \
        libqt4-opengl-dev \
        libswscale-dev \
        libtbb-dev \
        libtheora-dev \
        libtiff5-dev \
        libv4l-0 \
        libv4l-dev \
        libvorbis-dev \
        libx264-dev \
        libxvidcore-dev \
        perl \
        pkg-config \
        python3-matplotlib \
        python3-numpy \
        python3-pandas \
        python3-scipy \
        python3-tk \
        python3.4-dev \
        sphinx-common \
        texlive-latex-extra \
        unzip \
        wget \
        yasm

# download opencv

RUN mkdir -p "$OPENCV_SRC_DIR" && \
    cd "$OPENCV_SRC_DIR" && \
    wget -O opencv.zip "$OPENCV_SRC_URL/$OPENCV_VERSION.zip" && \
    unzip opencv.zip && \
    wget -O opencv_contrib.zip "$OPENCV_CONTRIB_URL/$OPENCV_VERSION.zip" && \
    unzip opencv_contrib.zip

# build opencv and opencv_contrib

RUN cp /usr/include/x86_64-linux-gnu/python3.4m/pyconfig.h \
       /usr/include/python3.4m/ && \
    cd "$OPENCV_SRC_DIR" && \
    rm opencv.zip && \
    rm opencv_contrib.zip && \
    cd "opencv-$OPENCV_VERSION" && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_C_EXAMPLES=ON \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D OPENCV_EXTRA_MODULES_PATH="$OPENCV_SRC_DIR/opencv_contrib-$OPENCV_VERSION/modules" \
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
        -D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.4m.so \
        -D PYTHON_INCLUDE_DIR=/usr/include/python3.4m/ \
        -D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python3.4m/ \
        -D PYTHON_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include/ \
        -D BUILD_opencv_java=OFF ..

RUN cd "$OPENCV_SRC_DIR/opencv-$OPENCV_VERSION/build" && \
    make && \
    make install && \
    /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' && \
    ldconfig

RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py

RUN pip3 install requests
