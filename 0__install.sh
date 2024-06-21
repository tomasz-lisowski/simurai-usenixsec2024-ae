#!/bin/bash
set -o errexit;  # Abort on non-zero exit status.
set -o nounset;  # Abort on unbound variable.
set -o pipefail; # Don't hide errors within pipes.
set -x;          # Print commands after applying all substitutions.

if [ `id -u` -ne 0 ]; then
    echo Please run this script as root or using sudo!;
    exit 1;
fi

platform() {
    source /etc/os-release;
    [[ ${ID} = "ubuntu" ]];
};

printf "0. Check platform is Ubuntu.\\n";
read -p "Press enter to run step...";
if ! platform; then
    printf "%s\\n" "Platform not supported. Need ubuntu."
    exit 1;
fi
printf "Platform is supported.\\n\\n";

printf "1. Check Docker.\\n"
read -p "Press enter to run step...";
docker run hello-world 2>&1 > /dev/null;
printf "Docker is installed correctly.\\n\\n";

printf "2. Build setup 0.\\n"
read -p "Press enter to run step...";
printf "TODO.\\n\\n";

printf "3. Build setup 1.\\n"
read -p "Press enter to run step...";
pushd .;
cd ./0__setup;
cd ./1__srsue;
./experiment__build;
popd;
printf "Done.\\n\\n";

printf "4. Build setup 2.\\n";
read -p "Press enter to run step...";
pushd .;
cd ./0__setup;
cd ./2__emulated_ue;
./experiment__build;
popd;
printf "Done.\\n\\n";
