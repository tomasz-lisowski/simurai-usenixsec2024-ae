#!/bin/bash
check_git() {
    which git 2>&1 > /dev/null;
    if [ $? -ne 0 ]; then
        return 1;
    else
        return 0;
    fi
}

check "If git is available."
check_git;
if ! checkResult "${?}" "Git is present." "Please install the git package."; then
    exit 1;
fi
