#!/bin/bash

# Map host's display socket to docker
DOCKER_ARGS+=("-v /tmp/.X11-unix:/tmp/.X11-unix")
DOCKER_ARGS+=("-v $HOME/.Xauthority:/home/admin/.Xauthority:rw")
DOCKER_ARGS+=("-e DISPLAY")
DOCKER_ARGS+=("-e NVIDIA_VISIBLE_DEVICES=all")
DOCKER_ARGS+=("-e NVIDIA_DRIVER_CAPABILITIES=graphics")

# Add serial port mapping
# DOCKER_ARGS+=("--device=/dev/ttyIMU")
# DOCKER_ARGS+=("--device=/dev/ttyGPS")

# Run container from image
docker run -it \
    --privileged \
    --network host \
    ${DOCKER_ARGS[@]} \
    -v /dev/*:/dev/* \
    -v /home/$USER/docker_mounted/:/root/docker_mounted/ \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --runtime=nvidia \
    --gpus all \
    --name "nav2" \
    --env="DISPLAY=$DISPLAY" \
    --user="root" \
    $@ \
    nav2:v1.0 \
    /bin/bash

