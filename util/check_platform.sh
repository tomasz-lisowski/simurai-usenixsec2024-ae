#!/bin/bash
platform() {
    source /etc/os-release;
    if [ ${ID} = "ubuntu" ]; then
        return 0;
    else
        return 1;
    fi
};

check "If platform is Ubuntu.";
platform;
if ! checkResult "${?}" "Platform is supported." "Platform is not supported. Need Ubuntu."; then
    exit 1;
fi
