FROM ros:kinetic

MAINTAINER iory ab.ioryz@gmail.com

RUN apt update && \
DEBIAN_FRONTEND=noninteractive apt install -y \
wget && \
rm -rf /var/lib/apt/lists/*
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -

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
ENV HOME /
WORKDIR /

RUN mkdir -p ${HOME}/ros_ws/src && \
    cd ${HOME}/ros_ws/src && \
    git clone https://github.com/RethinkRobotics/sawyer_simulator.git && \
    wstool init . && \
    wstool merge sawyer_simulator/sawyer_simulator.rosinstall && \
    wstool update

RUN cd ${HOME}/ros_ws && \
    rosdep update && \
    apt update && \
    rosdep install --from-paths --ignore-src -y -r src

RUN mv /bin/sh /bin/sh_tmp && ln -s /bin/bash /bin/sh
RUN source /opt/ros/${ROS_DISTRO}/setup.bash; cd ${HOME}/ros_ws; catkin build
RUN rm /bin/sh && mv /bin/sh_tmp /bin/sh
RUN touch ${HOME}/.bashrc && \
    echo "source $HOME/ros_ws/devel/setup.bash\n" >> ${HOME}/.bashrc && \
    echo "rossetip\n" >> ${HOME}/.bashrc && \
    echo "rossetmaster localhost"

COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
