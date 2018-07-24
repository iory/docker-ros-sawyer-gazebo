FROM ros:kinetic

MAINTAINER iory ab.ioryz@gmail.com

RUN apt update && \
DEBIAN_FRONTEND=noninteractive apt install -y \
python-catkin-tools \
python-rosinstall \
python-wstool \
gazebo7 \
ros-${ROS_DISTRO}-qt-build \
ros-${ROS_DISTRO}-gazebo-ros-control \
ros-${ROS_DISTRO}-gazebo-ros-pkgs \
ros-${ROS_DISTRO}-ros-control \
ros-${ROS_DISTRO}-control-toolbox \
ros-${ROS_DISTRO}-realtime-tools \
ros-${ROS_DISTRO}-ros-controllers \
ros-${ROS_DISTRO}-xacro \
ros-${ROS_DISTRO}-tf-conversions \
ros-${ROS_DISTRO}-kdl-parser \
ros-${ROS_DISTRO}-sns-ik-lib && \
rm -rf /var/lib/apt/lists/*
