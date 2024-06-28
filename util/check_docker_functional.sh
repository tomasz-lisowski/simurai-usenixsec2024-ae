#!/bin/bash
check "If Docker works.";
docker run --rm hello-world 2>&1 > /dev/null;
if ! checkResult "${?}" "Docker is working as expected." "Docker was not installed correctly. Take a look at https://docs.docker.com/engine/install/ubuntu/."; then
    exit 1;
fi
