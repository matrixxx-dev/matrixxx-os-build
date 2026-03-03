#!/bin/bash

## ########################################################################## ##
## apt-get update
##
## ########################################################################## ##
## start script with sudo:
[ "$(id -u)" != "0" ] && exec sudo "$0" "$@"
cd /SCRIPTS || exit 1

## definition:
LOGFILENAME="/info/$1-update.log"
PATH="./:${PATH}"; export PATH

## integration
. ./LIB/func_script-logging-handling
. ./LIB/func_apt-get-handling

## -------------------------------------------------------------------------- ##
## MAIN:
## -------------------------------------------------------------------------- ##
## re-synchronize the package index files from their sources
func_apt_get_update > "${LOGFILENAME}"

## -------------------------------------------------------------------------- ##
## pause:
#func_pause ""

## ########################################################################## ##
exit 0
