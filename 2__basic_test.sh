#!/bin/bash
readonly ROOT=$(dirname "$0");
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;
source ${UTIL}/check_root.sh

printf "Make sure to run this script after running ./0__install.sh.\\n";
read -p "Continue...";

source ${UTIL}/check_platform.sh;
source ${UTIL}/check_docker.sh;

printf "Basic test completed successfully!\\n";
