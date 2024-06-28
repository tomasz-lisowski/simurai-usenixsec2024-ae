#!/bin/bash
printf "Select the type of setup... (local/remote)";
read -p " " network__choice;
case "${network__choice}" in
    local ) printf "We will create a new cellular network. The local machine must have a BladeRF, SIMtrace2, and 2 UEs attached (via USB and ADB). One UE must have SIMtrace2 attached, the other must have a research SIM card.\\n" >&2; readonly NETWORK__LOCAL=true;;
    remote ) printf "We will use a cellular setup running on a remote host. The remote host must have a SIMtrace2, and 2 UEs attached (via USB and ADB). One UE must have the SIMtrace2 attached, the other must have a research SIM card. Make sure that the swICC PC/SC driver is installed and PC/SC middleware detects it.\\n" >&2; readonly NETWORK__LOCAL=false;;
    * ) printf "Invalid\\n" >&2; exit 1;;
esac
