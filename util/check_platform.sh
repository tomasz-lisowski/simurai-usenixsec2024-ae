#!/bin/bash
platform() {
    source /etc/os-release;
    [[ ${ID} = "ubuntu" ]];
};
if ! platform; then
    printf "Platform is not supported. Need Ubuntu.\\n"
    exit 1;
else
    printf "Platform is supported.\\n"
fi
