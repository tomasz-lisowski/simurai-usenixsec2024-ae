#!/bin/bash
readonly ROOT="$(realpath $(dirname "$0")/../..)";
readonly UTIL=""${ROOT}"/util";
source ${UTIL}/preamble.sh;
readonly HERE=""${ROOT}"/1__setup/1__physical_ue";

readonly NETWORK__LOCAL="${1:?Arg1 is missing: network remote (1) local (0).}";

pushd .;
cd ${HERE};

fileUninstall() {
    local path__root="${1:?Arg 1 missing: path}";

    pushd .;
    cd ${path__root};

    local file_list=$(find . -type f);
    for file in ${file_list}; do
        local path__absolute=${file:1};
        printf "Uninstall \"${path__absolute}\".\\n" >&2;
        rm "${path__absolute}";
        # This will keep custom folders nested inside /usr but it's much safer. We don't want to delete anything important!!!
    done

    popd;
    return 0;
}

check "If result exists."
checkDir "./result";
if checkResult "$?" "Result exists. Can proceed with uninstallation." "Precompiled libraries and binaries do not exist so will not be uninstalled.."; then
    printf "Uninstalling setup 1 binaries, libraries, and configs! %sAre you sure?...%s (yes/no)" ${CRED} ${CDEF};
    read -p " " choice;
    case "$choice" in
        yes ) printf "Yes\\n" >&2;;
        no ) printf "No\\n" >&2; exit 0;;
        * ) printf "Invalid\\n" >&2; exit 1;;
    esac

    if ${NETWORK__LOCAL}; then
        fileUninstall ""${HERE}"/result/bladerf";
        fileUninstall ""${HERE}"/result/yate";
        fileUninstall ""${HERE}"/result/libosmocore";
        fileUninstall ""${HERE}"/result/simtrace2";
    fi
    fileUninstall ""${HERE}"/result/scrcpy";

    rm -r ""${HERE}"/result";
fi

if ${NETWORK__LOCAL}; then
    pushd .;
    check "If swICC PC/SC reader can be uninstalled."
    cd ${HERE}/simurai/swicc-pcsc;
    make uninstall;
    if ! checkResult "$?" "swICC PC/SC reader was uninstalled." "Failed to uninstall swICC PC/SC reader."; then
        exit 1;
    fi
    popd;
fi

rm ""${HERE}"/docker/docker.log";
rm -r ""${HERE}"/simurai";
rm -r ""${HERE}"/log";

popd;
exit 0;