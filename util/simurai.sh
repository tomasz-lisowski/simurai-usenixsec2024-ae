#!/bin/bash
simuraiDownload() {
    local dir="${1:?Arg 1 missing: path to SIMurai.}";
    if ! checkDir "${dir}"; then
        if ! git clone --depth 1 --recurse-submodules --branch usenixsec2024-ae https://github.com/tomasz-lisowski/simurai.git "${dir}"; then
            return 1;
        fi
    fi
    return 0;
}
