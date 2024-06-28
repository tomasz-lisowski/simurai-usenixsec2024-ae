#!/bin/bash
readonly ROOT="$(realpath $(dirname "$0"))";
readonly UTIL="${ROOT}/util";
source ${UTIL}/preamble.sh;

printf "Basic test completed successfully!\\n";
