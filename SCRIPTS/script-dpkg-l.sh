#!/bin/bash

## ########################################################################## ##
## create dpkg list file
##
## ########################################################################## ##
## start script with sudo:
[ "$(id -u)" != "0" ] && exec sudo "$0" "$@"
cd /SCRIPTS || exit 1

## definition:
LOGFILENAME="$1"
PATH="./:${PATH}"; export PATH

## integration
. ./LIB/func_script-logging-handling
. ./LIB/func_apt-get-handling

## -------------------------------------------------------------------------- ##
## MAIN:
## -------------------------------------------------------------------------- ##
## write dpkg -l information to file
func_save_dpkg_list "/info" "${LOGFILENAME}"

## -------------------------------------------------------------------------- ##
## pause:
#func_pause ""

## ########################################################################## ##
exit 0
