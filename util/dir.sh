#!/bin/bash
checkDir() {
    local dir="${1:?Arg 1 missing: path}";
    if [[ -d "${dir}" ]]; then
        return 0;
    else
        return 1;
    fi
}

checkFile() {
    local file="${1:?Arg 1 missing: path}";
    if [[ -f "${file}" ]]; then
        return 0;
    else
        return 1;
    fi
}
