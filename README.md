Here's a container image with Ubuntu 16.04 LTS + OpenCV 3.4.1 + Python3 for ya.

It enables you to run any code that uses the OpenCV library, even GUI
code, on any OS that can run Docker - therefore you now can run your
OpenCV programs on almost any OS, without spending too much time
getting OpenCV to install properly.

## Getting started

1) Install Docker on your OS - we'll leave those details up to you to
figure out.
2) Clone this repository and cd to it
   ```
   git clone https://github.com/dorontal/docker-opencv-python
   cd docker-opencv-python
   ```
3) run
   ```
   build_image.sh
   ```
