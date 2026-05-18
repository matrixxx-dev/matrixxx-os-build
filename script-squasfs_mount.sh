#!/bin/bash

## ########################################################################## ##
## mount squashfs (virtual device):
##
## ########################################################################## ##
## start script with sudo:
#[ "$(id -u)" != "0" ] && exec sudo "$0" "$@"

## includes
source ./init
source ./lib/func_virtual-device-handling

## definitions
IMAGE_ARRAY=(
"LAYER1"
"LAYER2"
"LAYER3"
"LAYER4"
)

## -------------------------------------------------------------------------- ##
## FUNCTIONS:
## -------------------------------------------------------------------------- ##
func_process(){ # arch="$1"
  func_mount_virtual_devices "${TARGET_NAME}/$1"
}

func_mount_process(){
  ## separation of possible architectures
  func_arch_process
}

## -------------------------------------------------------------------------- ##
## MAIN:
## -------------------------------------------------------------------------- ##
## process
echo "TARGET_NAME: ${TARGET_NAME}"
func_mount_process

## -------------------------------------------------------------------------- ##
## pause:
echo "Press enter to continue..."; read -r

## ########################################################################## ##
exit 0
