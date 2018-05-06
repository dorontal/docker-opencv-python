# OpenCV 3.4.1 & Python3 (optimized, with GUI & video grabbing)

Here's a container image based on debian:jessie with:

* OpenCV 3.4.1
* Python 3.4
* GUI libraries (e.g. for cv2.imshow())
* Optimizations (Lapack, Eigen, IPP)
* Video grabbing libraries (ffmpeg, v4l, GStreamer)

It enables you to run any code that uses the OpenCV library, even GUI
code, on any OS that can run Docker - therefore you now can run your
OpenCV programs on almost any OS, without spending too much time
getting OpenCV to install properly.

## Getting started

### Creating the Docker image

* Install Docker on your OS - we'll leave those details up to you to
  figure out.
* Clone this repository and cd to it
  ```
  git clone https://github.com/dorontal/docker-opencv-python
  cd docker-opencv-python
  ```
* Run
  ```
  build_image.sh
  ```
### Running inside a container with the opencv-python image

* Run
  ```
  docker run -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -it opencv-python bash
  ```
  and you'll be in a bash shell that can pop up x windows (e.g. try `xterm`).
