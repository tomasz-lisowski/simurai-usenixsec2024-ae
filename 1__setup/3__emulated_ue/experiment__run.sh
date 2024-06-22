#!/bin/bash
rm -rf ./result;
mkdir result;

docker run -v ./modem_files:/firmwire/modem_files -v ./result:/opt/setup/result  -v ./FirmWire:/opt/setup/firmwire --tty --interactive --rm simurai/setup_3:1.0.0;
