#!/bin/bash
check() {
    local arg1="${1:?Arg 1 missing: check description}";
    printf "%sCHECK%s ${arg1}\\n" ${CCHK} ${CDEF} >&2;
}

checkResult() {
    local arg1="${1:?Arg 3 missing: condition}";
    local arg2="${2:?Arg 1 missing: good message}";
    local arg3="${3:?Arg 2 missing: bad message}";
    if [ ${arg1} -eq 0 ]; then
        printf "%sPASS%s ${arg2}\\n" ${CPASS} ${CDEF} >&2;
        return 0;
    else
        printf "%sFAIL%s ${arg3}\\n" ${CFAIL} ${CDEF} >&2;
        return 1;
    fi
}
