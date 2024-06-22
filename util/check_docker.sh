#!/bin/bash
if $(docker run hello-world 2>&1 > /dev/null); then
    printf "Docker is working as expected.\\n";
else
    printf "Docker was not installed correctly. Take a look at https://docs.docker.com/engine/install/ubuntu/.";
    exit 1;
fi
