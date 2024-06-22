#!/bin/bash
source ./util/preamble.sh
source ./util/check_root.sh

printf "1. Check platform is Ubuntu.\\n";
read -p "Press enter to run step...";
source ./util/check_platform.sh

printf "2. Check Docker.\\n"
read -p "Press enter to run step...";
source ./util/check_docker.sh

printf "3. Build setup 0.\\n"
read -p "Press enter to run step...";
printf "TODO.\\n\\n";

# printf "3. Build setup 1.\\n"
# read -p "Press enter to run step...";
# pushd .;
# cd ./0__setup;
# cd ./1__srsue;
# ./experiment__build;
# popd;
# printf "Done.\\n\\n";

# printf "4. Build setup 2.\\n";
# read -p "Press enter to run step...";
# pushd .;
# cd ./0__setup;
# cd ./2__emulated_ue;
# ./experiment__build;
# popd;
# printf "Done.\\n\\n";
