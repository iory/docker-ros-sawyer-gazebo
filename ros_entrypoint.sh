#!/bin/bash
set -e

# setup ros environment
if [ -z "${SETUP}" ]; then
    source "/home/ros/ros_ws/src/devel/setup.bash"
else
    source $SETUP
fi

exec "$@"