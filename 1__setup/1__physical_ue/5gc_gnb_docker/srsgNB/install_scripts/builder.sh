#!/bin/bash
set -e # stop executing after error

# Variables
FOLDER="/src"
BUILD_FOLDER="build"
MAKE_EXTRA="-j $(nproc)"
COMPILER="gcc"
UHD_VERSION="4.6.0.0"

export CC=/usr/bin/gcc
export CXX=/usr/bin/g++


cd "$FOLDER" || exit

# Setup UHD
uhd_system_version=$(uhd_config_info --version) && regex="^UHD ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*" && [[ $uhd_system_version =~ $regex ]]
uhd_system_version="${BASH_REMATCH[1]}"
if [[ -z "$UHD_VERSION" || "$UHD_VERSION" == "$uhd_system_version" ]]; then
    echo "Using default UHD $uhd_system_version"
else
    [ ! -d "/opt/uhd/$UHD_VERSION" ] && echo "UHD version not found" && exit 1
    export UHD_DIR="/opt/uhd/$UHD_VERSION"
    echo "UHD_DIR set to $UHD_DIR"
fi

# Build process
mkdir -p "$BUILD_FOLDER"
cd "$BUILD_FOLDER" || exit
cmake "$@" ..
make $MAKE_EXTRA
