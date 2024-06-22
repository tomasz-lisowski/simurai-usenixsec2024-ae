#!/bin/bash
printf "%sCHECK%s Running as root or with sudo.\\n" ${CCHK} ${CDEF};
if [ `id -u` -ne 0 ]; then
    printf "  %sFAIL%s.\\n" ${CFAIL} ${CDEF};
    exit 1;
else
    printf "  %sPASS%s.\\n" ${CPASS} ${CDEF};
fi
