#!/bin/bash
set -o errexit;  # Abort on non-zero exit status.
set -o nounset;  # Abort on unbound variable.
set -o pipefail; # Don't hide errors within pipes.
set -x;          # Print commands after applying all substitutions.

if [ `id -u` -ne 0 ]; then
    echo Please run this script as root or using sudo!;
    exit 1;
fi

printf "0. Build setup 0.\\n"
read -p "Press enter to run step...";
printf "TODO.\\n\\n"

printf "1. Build setup 1.\\n"
read -p "Press enter to run step...";
pushd .;
cd ./0__setup;
cd ./1__srsue;
./experiment__build;
popd;
printf "Done.\\n\\n"

printf "2. Build setup 2.\\n"
read -p "Press enter to run step...";
pushd .;
cd ./0__setup;
cd ./2__emulated_ue;
./experiment__build;
popd;
printf "Done.\\n\\n"
