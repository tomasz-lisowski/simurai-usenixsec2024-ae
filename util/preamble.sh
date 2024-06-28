#!/bin/bash
set -o nounset;  # Abort on unbound variable.
set -o pipefail; # Don't hide errors within pipes.
#set -o errexit;  # Abort on non-zero exit status.
#set -x;          # Print commands after applying all substitutions.

source ${UTIL}/color.sh;
source ${UTIL}/dir.sh;
source ${UTIL}/checker.sh;
# source ${UTIL}/check_root.sh;
source ${UTIL}/simurai.sh;
source ${UTIL}/check_git.sh;
source ${UTIL}/check_platform.sh;
source ${UTIL}/check_docker_functional.sh;
