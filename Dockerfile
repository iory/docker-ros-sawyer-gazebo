FROM ros:kinetic

MAINTAINER iory ab.ioryz@gmail.com

RUN apt update && \
DEBIAN_FRONTEND=noninteractive apt install -y \
python-catkin-tools \
python-rosinstall \
python-wstool \
gazebo7 \
ros-${ROS_DISTRO}-jsk-tools \
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

RUN useradd -G sudo -u 1000 --create-home ros
ENV HOME /home/ros
WORKDIR /home/ros

RUN mkdir -p ~/ros_ws/src && \
    cd ~/ros_ws/src && \
    git clone https://github.com/RethinkRobotics/sawyer_simulator.git && \
    wstool init . && \
    wstool merge sawyer_simulator/sawyer_simulator.rosinstall && \
    wstool update && \
    rosdep install -r -y --from-paths src --ignore-src .

RUN mv /bin/sh /bin/sh_tmp && ln -s /bin/bash /bin/sh
RUN source /opt/ros/${ROS_DISTRO}/setup.bash; cd ~/ros_ws; catkin build
RUN rm /bin/sh && mv /bin/sh_tmp /bin/sh
RUN touch ~/.bashrc && \
    echo "source $HOME/ros_ws/src/devel/setup.bash\n" >> ~/.bashrc && \
    echo "rossetip\n" >> /root/.bashrc && \
    echo "rossetmaster localhost"

COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
