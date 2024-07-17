#!/bin/bash
readonly ROOT="$(realpath $(dirname "$0")/../..)";
readonly UTIL="${ROOT}/util";
source ${UTIL}/preamble.sh;
readonly HERE="${ROOT}/1__setup/1__physical_ue";

readonly NETWORK__LOCAL="${1:?Arg1 is missing: network remote (1) local (0).}";

pushd .;
cd ${HERE};

readonly SIMURAI=""${HERE}"/simurai";

#==1. Download and build SIMurai.===============================================

check "If SIMurai can be downloaded to \""${SIMURAI}"\".";
simuraiDownload "${SIMURAI}";
if ! checkResult "$?" "SIMurai was downloaded." "Failed to download SIMurai."; then
    exit 1;
fi

check "If SIMurai exists at \""${SIMURAI}"\".";
checkDir "${SIMURAI}";
if ! checkResult "$?" "SIMurai exists." "SIMurai is missing."; then
    exit 1;
fi

pushd .;
check "If SIMurai can be built.";
(cd "${SIMURAI}" && ./docker.sh);
if ! checkResult "$?" "SIMurai was built." "Failed to build SIMurai."; then
    exit 1;
fi
popd;

#==2. Compile the 2G cellular network and scrcpy for phone inspection.==========

pushd .;
check "Create docker image with precompiled binaries, libraries, and configs.";
cd ./docker && docker build --progress=plain . -t simurai/s1:1.0.0 2>&1 | tee docker.log;
if ! checkResult "$?" "Image built." "Failed to build image."; then
    exit 1;
fi
popd;

pushd .;
check "Run docker container.";
rm -rf ""${HERE}"/result";
mkdir ""${HERE}"/result";
docker run -v ""${HERE}"/result":/opt/result --tty --interactive --rm simurai/s1:1.0.0;
if ! checkResult "$?" "Container ran successfully." "Failed to run container."; then
    exit 1;
fi
popd;

#==3. Overwrite the default Yate config with a pre-configured set of configs.===

if [ ${NETWORK__LOCAL} -eq 0 ]; then
    # Remove default yate config and replace it with our own.
    rm -r ""${HERE}"/result/yate/usr/local/etc/yate";
    cp -r ""${HERE}"/config/yate" ""${HERE}"/result/yate/usr/local/etc/yate";
fi

#==4. Install binaries, libraries, and configs.=================================

checkFileInstallNot() {
    local path__root="${1:?Arg 1 missing: path}";
    local description="${2:?Arg 2 missing: description}";

    pushd .;
    cd ${path__root};

    local file_list=$(find . -type f);
    for file in ${file_list}; do
        local path__absolute=${file:1};
        printf "Checking \"${path__absolute}\".\\n";
        if checkFile "${path__absolute}"; then
            printf "Cannot proceeed, ${description}-related file \"${path__absolute}\" already exists. Remove it before retrying the installation (e.g., with the uninstall script).\\n" >&2;
            popd;
            return 1;
        fi
    done

    popd;
    return 0;
}

fileInstall() {
    local path__root="${1:?Arg 1 missing: path}";

    pushd .;
    cd ${path__root};

    local file_list=$(find . -type f);
    for file in ${file_list}; do
        local path__absolute=${file:1};
        local path__absolute__dir=$(dirname ${path__absolute});
        local path__local=$(realpath ${file});
        printf "Install \"${path__local}\" to \"${path__absolute}\".\\n" >&2;
        mkdir -p "${path__absolute__dir}";
        cp "${path__local}" "${path__absolute}";
    done

    popd;
    return 0;
}

if [ ${NETWORK__LOCAL} -eq 0 ]; then
    check "If BladeRF is already installed.";
    checkFileInstallNot "./result/bladerf" "BladeRF";
    if ! checkResult "$?" "BladeRF-related files don't already exist." "BladeRF-related files exist."; then
        printf "%sDo you want to continue anyways, it will overwrite existing files?...%s (yes/no)" ${CRED} ${CDEF};
        read -p " " choice;
        case "$choice" in
            yes ) ;;
            no ) exit 1;;
            * ) exit 1;;
        esac
    fi
    check "If Yate is already installed.";
    checkFileInstallNot "./result/yate" "Yate/YateBTS";
    if ! checkResult "$?" "Yate/YateBTS-related files don't already exist." "Yate/YateBTS-related files exist."; then
        printf "%sDo you want to continue anyways, it will overwrite existing files?...%s (yes/no)" ${CRED} ${CDEF};
        read -p " " choice;
        case "$choice" in
            yes ) ;;
            no ) exit 1;;
            * ) exit 1;;
        esac
    fi
    check "If libosmocore is already installed.";
    checkFileInstallNot "./result/libosmocore" "libosmocore";
    if ! checkResult "$?" "Libosmocore-related files don't already exist." "Libosmocore-related files exist."; then
        printf "%sDo you want to continue anyways, it will overwrite existing files?...%s (yes/no)" ${CRED} ${CDEF};
        read -p " " choice;
        case "$choice" in
            yes ) ;;
            no ) exit 1;;
            * ) exit 1;;
        esac
    fi
    check "If simtrace2 is already installed.";
    checkFileInstallNot "./result/simtrace2" "simtrace2";
    if ! checkResult "$?" "SIMtrace2-related files don't already exist." "SIMtrace2-related files exist."; then
        printf "%sDo you want to continue anyways, it will overwrite existing files?...%s (yes/no)" ${CRED} ${CDEF};
        read -p " " choice;
        case "$choice" in
            yes ) ;;
            no ) exit 1;;
            * ) exit 1;;
        esac
    fi
fi
check "If scrcpy is already installed.";
checkFileInstallNot "./result/scrcpy" "scrcpy";
if ! checkResult "$?" "scrcpy-related files don't already exist." "scrcpy-related files exist."; then
    printf "%sDo you want to continue anyways, it will overwrite existing files?...%s (yes/no)" ${CRED} ${CDEF};
    read -p " " choice;
    case "$choice" in
        yes ) ;;
        no ) exit 1;;
        * ) exit 1;;
    esac
fi

# If we install the files now, they will not overwrite any existing files on this system unless explicitly allowed.
if [ ${NETWORK__LOCAL} -eq 0 ]; then
    fileInstall "./result/bladerf";
    fileInstall "./result/yate";
    fileInstall "./result/libosmocore";
    fileInstall "./result/simtrace2";
    # TODO: Install UDEV rules for BladeRF.
fi
fileInstall "./result/scrcpy";
ldconfig;

#==5. Install runtime dependencies.=============================================

if [ ${NETWORK__LOCAL} -eq 0 ]; then
    check "If dependencies need to be installed.";
    dpkg -s make &&  dpkg -s pkgconf &&  dpkg -s pcscd && dpkg -s libpcsclite1 && dpkg -s libpcsclite-dev && dpkg -s adb &&  dpkg -s tmux &&  dpkg -s procps &&  dpkg -s libtalloc2 && dpkg -s libsctp1 && dpkg -s liburing2 && dpkg -s dfu-util;
    if ! checkResult "$?" "Dependencies are present." "Dependencies are not present."; then
        read -p "'make pkgconf pcscd libpcsclite1 libpcsclite-dev adb tmux procps libtalloc2 libsctp1 liburing2 dfu-util' packages will be installed now, but it will not be uninstalled by the uninstall script... ";
        apt-get -qq --yes --no-install-recommends install make pkgconf pcscd libpcsclite1 libpcsclite-dev adb tmux procps libtalloc2 libsctp1 liburing2 dfu-util;
        ldconfig;
    fi

    pushd .;
    cd ""${HERE}"/simurai/swicc-pcsc";
    check "If we can build the swICC PC/SC readear.";
    (./docker.sh);
    make install;
    if ! checkResult "$?" "swICC PC/SC reader was installed." "Failed to install swICC PC/SC reader."; then
        exit 1;
    fi
    popd;
fi

popd;
exit 0;
