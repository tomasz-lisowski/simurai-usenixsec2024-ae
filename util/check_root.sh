#!/bin/bash
if [ `id -u` -ne 0 ]; then
    printf "Please run this script as root or using sudo.\\n";
    exit 1;
fi
