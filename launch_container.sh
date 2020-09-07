#!/bin/sh

mkdir -p jetpack_home/nvidia
mkdir -p jetpack_home/Downloads
JETPACK_HOME=$(realpath ./jetpack_home)

docker run --privileged --rm -it \
           --env=DISPLAY=$DISPLAY \
           --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
           --env="QT_X11_NO_MITSHM=1" \
           --volume=/dev:/dev:rw \
           --volume=$JETPACK_HOME/nvidia:/home/jetpack/nvidia:rw \
           --volume=$JETPACK_HOME/Downloads:/home/jetpack/Downloads:rw \
           --shm-size=2gb \
           --env=TERM=xterm-256color \
           --net=host \
           jetpack:latest \
           bash