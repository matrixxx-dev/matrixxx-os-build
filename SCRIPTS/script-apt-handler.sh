#!/bin/bash

## ########################################################################## ##
## apt handler:
##
## ########################################################################## ##
## start script with sudo:
[ "$(id -u)" != "0" ] && exec sudo "$0" "$@"
cd /SCRIPTS || exit 1

## definition:
PREFIX="$1"; POSTFIX="$2"
#TYPE="${PREFIX//[0-9]/}"
#NUMBER="${PREFIX//[a-zA-Z]/}"
CATEGORY_COLLECTION_FILE="${PREFIX}-category-file-list${POSTFIX}"
LOGFILENAME="${PREFIX}-$(basename "$0")"
PATH="./:${PATH}"; export PATH
ARCHITECTURE=$(dpkg --print-architecture)

APT_HANDLER_ERROR=""

## integration
. ./LIB/system-baseconfig
. ./LIB/func_script-logging-handling
. ./LIB/func_apt-get-handling
. ./LIB/func_category-file-handling

## check on avaiable category file
if [ -f ./categories/"${CATEGORY_COLLECTION_FILE}" ]; then
  func_echo "use ./categories/${CATEGORY_COLLECTION_FILE}:"
  . ./categories/"${CATEGORY_COLLECTION_FILE}"
else
  exit 1
fi

## -------------------------------------------------------------------------- ##
## MAIN:
## -------------------------------------------------------------------------- ##
## time measurement: start
main_start=$(date +%s)

## logging handling switched on
func_init_log_file "/info" "${LOGFILENAME}"

## -----------------------
## process install packages declared in category files
func_echo_base_topic "Process category file: ${CATEGORY_COLLECTION_FILE}"
func_process_category_files || APT_HANDLER_ERROR="err"
## -----------------------

## write dpkg -l information to file
func_save_dpkg_list "/info" "${LOGFILENAME}"

## time measurement: end
period=$(($(date +%s) - main_start))
func_echo_topic "Processing - elapsed time: ${period} seconds"

## -------------------------------------------------------------------------- ##
## pause:
#func_pause ""

## ########################################################################## ##
[ "${APT_HANDLER_ERROR}" = "err" ] && exit 1
exit 0

