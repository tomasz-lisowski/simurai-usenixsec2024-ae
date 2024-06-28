#!/bin/bash
readonly CDEF=$(tput sgr0);

readonly CBLK=$(tput setaf 0);
readonly CRED=$(tput setaf 1);
readonly CGRN=$(tput setaf 2);
readonly CYEL=$(tput setaf 3);
readonly CBLU=$(tput setaf 4);
readonly CMAG=$(tput setaf 5);
readonly CCYN=$(tput setaf 6);
readonly CWHT=$(tput setaf 7);

readonly CPASS=${CGRN};
readonly CFAIL=${CRED};
readonly CCHK=${CYEL};
