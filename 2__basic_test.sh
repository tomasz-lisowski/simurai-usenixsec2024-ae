#!/bin/bash
set -o errexit;  # Abort on non-zero exit status.
set -o nounset;  # Abort on unbound variable.
set -o pipefail; # Don't hide errors within pipes.
#set -x;         # Print commands after applying all substitutions.

if [ `id -u` -ne 0 ]; then
    echo Please run this script as root or using sudo!;
    exit 1;
fi

printf "Make sure to run this script after running ./0__install.sh.\\n";
read -p "Continue...";

printf "TODO.\\n";

printf "Basic test completed successfully!\\n";
