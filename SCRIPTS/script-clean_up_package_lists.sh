#!/bin/bash

## ########################################################################## ##
## cleanup:
## delete package cache [apt-get clean] and the package list files
##
## ########################################################################## ##
## start script with sudo:
[ "$(id -u)" != "0" ] && exec sudo "$0" "$@"
cd /SCRIPTS || exit 1

## definition:
PATH="./:${PATH}"; export PATH

## integration
. ./LIB/func_script-logging-handling
. ./LIB/func_apt-get-handling

## -------------------------------------------------------------------------- ##
## MAIN:
## -------------------------------------------------------------------------- ##
## delete local repository and package list files
func_clean_up_package_lists

## -------------------------------------------------------------------------- ##
## pause:
#func_pause ""

## ########################################################################## ##
exit 0
