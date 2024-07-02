#!/bin/bash

readonly ROOT=$(realpath $(dirname "$0")/../..);
readonly HERE=${ROOT}/1__setup/3__emulated_ue;

pushd .;
cd ${HERE};

rm -rf ./log;
mkdir log;

docker run -v ./modem_files:/firmwire/modem_files -v ./log:/opt/setup/log  -v ./FirmWire:/opt/setup/firmwire --tty --interactive --rm simurai/s3:1.0.0;

popd;
exit 0;
