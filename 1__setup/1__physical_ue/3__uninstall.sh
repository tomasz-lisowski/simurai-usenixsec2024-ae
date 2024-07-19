#!/bin/bash
readonly ROOT="$(realpath $(dirname "$0")/../..)";
readonly UTIL=""${ROOT}"/util";
source ${UTIL}/preamble.sh;
readonly HERE=""${ROOT}"/1__setup/1__physical_ue";

readonly NETWORK__CHOICE="${1:?Argument 1 is missing: Expected a selection for the type of setup to run: remote (1), local (0), hybrid (2).}";

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
        rm -f "${path__absolute}";
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

    if [ ${NETWORK__CHOICE} -eq 2 ] || [ ${NETWORK__CHOICE} -eq 0 ]; then
        if [ ${NETWORK__CHOICE} -eq 0 ]; then
            fileUninstall ""${HERE}"/result/bladerf";
            fileUninstall ""${HERE}"/result/yate";
        fi
        fileUninstall ""${HERE}"/result/libosmocore";
        fileUninstall ""${HERE}"/result/simtrace2";
    fi
    fileUninstall ""${HERE}"/result/scrcpy";

    rm -rf ""${HERE}"/result";
fi

if [ ${NETWORK__CHOICE} -eq 2 ] || [ ${NETWORK__CHOICE} -eq 0 ]; then
    pushd .;
    check "If swICC PC/SC reader can be uninstalled."
    cd ${HERE}/simurai/swicc-pcsc;
    make uninstall;
    if ! checkResult "$?" "swICC PC/SC reader was uninstalled." "Failed to uninstall swICC PC/SC reader."; then
        exit 1;
    fi
    popd;
fi

rm -f ""${HERE}"/docker/docker.log";
rm -rf ""${HERE}"/simurai";
rm -rf ""${HERE}"/log";

rm -f ""${HERE}"/fs.simfs";

popd;
exit 0;
