#!/bin/sh

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

mkdir -p jetpack_home/nvidia
mkdir -p jetpack_home/Downloads
JETPACK_HOME=$(realpath ./jetpack_home)

docker run --privileged --rm -it \
           --runtime=nvidia \
           --env=DISPLAY=$DISPLAY \
           --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
           --env="QT_X11_NO_MITSHM=1" \
           --volume=/dev:/dev:rw \
           --volume=$JETPACK_HOME/nvidia:/home/jetpack/nvidia:rw \
           --volume=$JETPACK_HOME/Downloads:/home/jetpack/Downloads:rw \
           -v /etc/group:/etc/group:ro \
           -v /etc/passwd:/etc/passwd:ro \
           --shm-size=2gb \
           --net=host \
           -u "ytpc2020d"  \
           jetpack:latest
