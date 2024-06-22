#!/bin/bash
source ../../util/preamble.sh;
source ../../util/check_root.sh;

platform() {
    source /etc/os-release;
    [[ ${ID} = "ubuntu" ]]
};

printf "1. Check platform is Ubuntu.\\n"
source ../../util/check_platform.sh;

pushd .
cd ./docker
sudo docker build --progress=plain . -t simurai/setup_2:1.0.0 2>&1 | tee build.log
popd
