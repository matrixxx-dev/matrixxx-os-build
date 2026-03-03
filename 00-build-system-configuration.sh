#!/bin/bash

## ########################################################################## ##
## create the necessary system configuration
##
## ########################################################################## ##
#SCRIPT_STATUS="ON"

## include
source ./init

## overwriting:
DIR_PREFIX="${BASE_SYSTEM_PREFIX}_"

## include
source ./"${BASE_SYSTEM_CONFIG}"/init--process-control
source ./"${BASE_SYSTEM_CONFIG}"/init_distribution
source ./"${BASE_SYSTEM_CONFIG}"/lib/func_system-config-modernize

## -------------------------------------------------------------------------- ##
## FUNCTIONS:
## -------------------------------------------------------------------------- ##
func_process(){ # arch="$1"
  func_LIST_handling "${TARGZ_to_DIR}"
  func_gen_sources_list_file "./${BASE_SYSTEM_CONFIG}"
  func_gen_apt_conf_file "./${BASE_SYSTEM_CONFIG}"
  func_LIST_handling "${DIR_to_TARGZ}"
}

## -------------------------------------------------------------------------- ##
## MAIN:
## -------------------------------------------------------------------------- ##
if [ "${SCRIPT_STATUS}" != "ON" ]; then
  echo "'$(basename "$0")' has to be enabled!"; read -r; exit 1
else
  func_process
fi

## -------------------------------------------------------------------------- ##
## pause:
echo "Press enter to continue..."; read -r

## ########################################################################## ##
exit 0
