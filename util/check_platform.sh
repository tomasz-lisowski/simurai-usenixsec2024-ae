#!/bin/bash
platform() {
    source /etc/os-release;
    [[ ${ID} = "ubuntu" ]];
};

printf "%sCHECK%s Platform == Ubuntu.\\n" ${CCHK} ${CDEF};
if ! platform; then
    printf "  %sFAIL%s. Platform is not supported. Need Ubuntu.\\n" ${CFAIL} ${CDEF};
    exit 1;
else
    printf "  %sPASS%s. Platform is supported.\\n" ${CPASS} ${CDEF};
fi
