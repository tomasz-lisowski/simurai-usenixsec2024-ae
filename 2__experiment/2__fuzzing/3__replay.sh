#!/bin/bash
readonly ROOT=$(realpath $(dirname "$0")/../..);
readonly UTIL=${ROOT}/util;
source ${UTIL}/preamble.sh;

readonly HERE="${ROOT}/2__experiment/2__fuzzing"
readonly SETUP3="${ROOT}/1__setup/3__emulated_ue"
readonly MODEM="${SETUP3}/modem_files"
readonly FIRMWIRE="${SETUP3}/FirmWire"

check_received_args_count() {
    if [ $1 == $2 ]; then
        return 0;
    else
        return 1;
    fi
};


check "Checking if argument was provided."
check_received_args_count $# 1
if ! checkResult "${?}" "Script Received Argument" "No arguments provided, printing program usage"; then
    echo ""
    echo "Usage: $0 replay_target"
    echo "- replay_target: Testcase or directory to replay in firmwire as USAT fuzz input."
    echo "                 If a directory is provided, all contained files are replayed as testcases."
    exit -1
fi

INPUT="${1}"

check "Checking if argument is directory or a file."
checkDir $INPUT  ||  checkFile $INPUT
if ! checkResult "${?}" "Argument is directory or a file" "Argument is neither directory nor a file. Please specify the testcase/directory to replay!"; then
    exit -1
fi


pushd .;
cd ${HERE};

if checkFile $INPUT; then
    echo "Received File as input, running in single test case replay mode"
    TESTCASE_PATH=$(realpath $(dirname "$INPUT"));
    TESTCASE_FILE=$(basename $INPUT)

    docker run -v "${MODEM}":/firmwire/modem_files \
        -v ${HERE}/result:/opt/setup/result \
        -v "${FIRMWIRE}":/opt/setup/firmwire \
        -v ${HERE}/scripts:/opt/setup/scripts \
        -v ${HERE}/AFLplusplus:/opt/setup/AFLplusplus \
        -v ${TESTCASE_PATH}:/firmwire/replay \
        --tty --interactive --rm \
        --entrypoint /opt/setup/scripts/3a__replay_single.sh \
        simurai/setup_3:1.0.0 \
        ${TESTCASE_FILE} \
    ;
fi

if checkDir $INPUT; then
    echo "Received directory as input, running in directory replay mode"
    TESTCASE_DIR=$(realpath $(dirname "$INPUT"));
    TESTCASE_DIR_NAME=$(basename $INPUT)

    docker run -v "${MODEM}":/firmwire/modem_files \
        -v ${HERE}/result:/opt/setup/result \
        -v "${FIRMWIRE}":/opt/setup/firmwire \
        -v ${HERE}/scripts:/opt/setup/scripts \
        -v ${HERE}/AFLplusplus:/opt/setup/AFLplusplus \
        -v ${TESTCASE_DIR}/${TESTCASE_DIR_NAME}:/firmwire/replay/${TESTCASE_DIR_NAME} \
        --tty --interactive --rm \
        --entrypoint /opt/setup/scripts/3b__replay_multi.sh \
        simurai/setup_3:1.0.0 \
        ${TESTCASE_DIR_NAME} \
    ;
fi


popd;
exit 0;
