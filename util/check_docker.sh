#!/bin/bash
printf "%sCHECK%s Docker works.\\n" ${CCHK} ${CDEF};
if $(docker run hello-world 2>&1 > /dev/null); then
    printf "  %sPASS%s. Docker is working as expected.\\n" ${CPASS} ${CDEF};
else
    printf "  %sFAIL%s. Docker was not installed correctly. Take a look at https://docs.docker.com/engine/install/ubuntu/.\\n" ${CFAIL} ${CDEF};
    exit 1;
fi
