FROM dustynv/l4t-pytorch:r36.2.0

#nvidia-container-runtime 
# ENV NVIDIA_VISIBLE_DEVICES \
#     ${NVIDIA_VISIBLE_DEVICES:-all} 
# ENV NVIDIA_DRIVER_CAPABILITIES \
#     ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics 

# USER root 

# setup timezone
# RUN echo 'Etc/UTC' > /etc/timezone && \
#     ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
#     apt-get update && \
#     apt-get install -q -y --no-install-recommends tzdata && \
#     rm -rf /var/lib/apt/lists/*

# install packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN set -eux; \
       key='C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654'; \
       export GNUPGHOME="$(mktemp -d)"; \
       gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
       mkdir -p /usr/share/keyrings; \
       gpg --batch --export "$key" > /usr/share/keyrings/ros2-latest-archive-keyring.gpg; \
       gpgconf --kill all; \
       rm -rf "$GNUPGHOME"

# setup sources.list
RUN echo "deb [ signed-by=/usr/share/keyrings/ros2-latest-archive-keyring.gpg ] http://packages.ros.org/ros2/ubuntu jammy main" > /etc/apt/sources.list.d/ros2-latest.list

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV ROS_DISTRO humble

# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-ros-core=0.10.0-1* \
    && rm -rf /var/lib/apt/lists/*

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

# Prevent console from interacting with the user
ARG DEBIAN_FRONTEND=noninteractive

# Prevent hash mismatch error for apt-get update
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && apt-get update -yqqq

# Set folder for RUNTIME_DIR
# RUN mkdir tmp/runtime-root && chmod 0700 tmp/runtime-root
# ENV XDG_RUNTIME_DIR='/tmp/runtime-root'

# Install non-Python/ROS dependencies
RUN apt-get install --no-install-recommends -yqqq \
    python3-pip

# Set up ROS 2 workspace
ARG WORKSPACE=/root/ros2_ws
ENV WORKSPACE=$WORKSPACE
WORKDIR $WORKSPACE

# Set ROS2 environment variables in /root/.bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc && \
    echo "export ROS_DOMAIN_ID=34" >> /root/.bashrc && \
    echo "export ROS_LOCALHOST_ONLY=1" >> /root/.bashrc && \
    echo "echo 'ROS2 environment set, Domain = 34'" >> /root/.bashrc

# Set ROS2 Humble and ROS aliases in /root/.bashrc
RUN echo "source ~/ros2_ws/install/local_setup.bash" >> /root/.bashrc && \
    echo "alias cw='cd ~/ros2_ws'" >> /root/.bashrc && \
    echo "alias cs='cd ~/ros2_ws/src'" >> /root/.bashrc && \
    echo "alias cb='cd ~/ros2_ws && colcon build --symlink-install'" >> /root/.bashrc && \
    echo "alias cbp='cd ~/ros2_ws && colcon build --symlink-install --packages-select'" >> /root/.bashrc && \
    echo "alias sb='source ~/.bashrc'" >> /root/.bashrc && \
    echo "alias gb='gedit ~/.bashrc'" >> /root/.bashrc && \
    echo "alias rt='ros2 topic list'" >> /root/.bashrc && \
    echo "alias re='ros2 topic echo'" >> /root/.bashrc && \
    echo "alias rn='ros2 node list'" >> /root/.bashrc && \
    echo "alias testpub='ros2 run demo_nodes_cpp talker'" >> /root/.bashrc && \
    echo "alias testsub='ros2 run demo_nodes_cpp listener'" >> /root/.bashrc

# ROS-BASE upgrade

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep \
    python3-vcstool \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

# setup colcon mixin and metadata
RUN colcon mixin add default \
      https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
    colcon mixin update && \
    colcon metadata add default \
      https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
    colcon metadata update

# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-ros-base=0.10.0-1* \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-desktop=0.10.0-1* \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-desktop-full=0.10.0-1* \
    && rm -rf /var/lib/apt/lists/*
    
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3-pip \
    terminator \
    gedit \
    cmake \
    git \
    vim \
    tree \
    software-properties-common \
    apt-transport-https \
    wget \
    && rm -rf /var/lib/apt/lists/*
