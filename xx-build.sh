#!/bin/bash

## ########################################################################## ##
## build process
##
## ########################################################################## ##

## integration
source ./init
[ -f ./SCRIPTS/categories/init ] && source ./SCRIPTS/categories/init

## -------------------------------------------------------------------------- ##
## FUNCTIONS:
## -------------------------------------------------------------------------- ##
## creating layers
func_process_layer(){ # arch="$1"
  local arch target union mountpoint info_dir
  arch="$1";
  target="./${TARGET_NAME}/${arch}"; union="${target}/${MNT_UNION_DIR}"
  info_dir="${target}/info"
  mountpoint="${target}/${MOUNT_DIR}/${UPPER_OVERLAY_NAME}.img"

  func_init_log_file "${info_dir}" "${SCRIPT_SELECTOR}-build-process"

  ## pre-process ...
  ## ---------------
  ## get upper overlay image (see USE_QCOW_TEMPLATE_FILE - copy or creation)
  func_get_upper_overlay_image "${target}"

  ##  mount the unionfs
  func_mount_unionfs "${target}" "${UPPER_OVERLAY_NAME}" \
    "${OVERLAY_BASE_NAME}" "${union}"

  ## ------------------------------------------------------------------------ ##

  ## debootstrap process (only once - as long as /proc does not exist)
  func_debootstrap_handling "${arch}"

  ## copy files from host to chroot environment to enable the installation
  func_configure_system_INSTALLATION "${mountpoint}"

  ## init chroot environment
  func_pre_process_chroot "${union}"

  ## process ...
  ## -----------
  func_process_call_scripts "${union}"

  ## post-process ...
  ## ----------------
  ## reset chroot environment
  func_post_process_chroot "${union}"

  ## reset chroot environment on upper layer
  func_configure_system_USAGE "${target}" "${mountpoint}"

  ## ------------------------------------------------------------------------ ##

  ## unmount the unionfs
  func_unmount_unionfs "${target}" "${UPPER_OVERLAY_NAME}" \
    "${OVERLAY_BASE_NAME}" "${union}"

  ## create a layer
  [ "${LAYER_BUILD_MARKER}" = "true" ] && func_layer_handling "${arch}"
}

## preparation for creating layers
func_process(){ # arch="$1"
  local arch character
  arch="$1"
  for character in "${SELECTOR_ARRAY[@]}"; do
    SCRIPT_SELECTOR="${character}"
    LAYER_BUILD_MARKER="false"
    func_process_layer "${arch}"
  done
}

## include time measurement and process global architecture handling
func_build_process(){
  local start_complete log_file

  ## time measurement: start
  start_complete=$(date +%s)

  ## separation of possible architectures
  func_arch_process

  ## log file handling
  func_save_log_file "xx-build-process-timing-${SELECTOR_ARRAY[*]}.log" \
    "${start_complete}"
}

## -------------------------------------------------------------------------- ##
## MAIN:
## -------------------------------------------------------------------------- ##
func_build_process
./script-log-file-evaluation.sh

## -------------------------------------------------------------------------- ##
## pause:
echo "Press enter to continue..."; read -r

## ########################################################################## ##
exit 0
