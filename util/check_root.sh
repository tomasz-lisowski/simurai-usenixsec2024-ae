#!/bin/bash
check_root() {
    if [ $(id -u) -ne 0 ]; then
        return 1;
    else
        return 0;
    fi
}

check "If running as root or with sudo."
check_root;
if ! checkResult "${?}" "We are root." "Please run this script as root or using sudo."; then
    exit 1;
fi
