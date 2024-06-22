#!/bin/bash
set -o errexit;  # Abort on non-zero exit status.
set -o nounset;  # Abort on unbound variable.
set -o pipefail; # Don't hide errors within pipes.
#set -x;          # Print commands after applying all substitutions.
source ${UTIL}/color.sh;
