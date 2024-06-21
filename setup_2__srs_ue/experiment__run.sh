#!/bin/bash
rm -rf ./result;
mkdir result;
sudo docker run --privileged -v ./result:/opt/setup/result --tty --interactive --rm simurai/setup_2:1.0.0;
