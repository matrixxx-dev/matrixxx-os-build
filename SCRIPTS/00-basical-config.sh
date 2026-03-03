#!/bin/bash

## ########################################################################## ##
## basical configuration: after debootstrap handling
##
## ########################################################################## ##
## start script with sudo:
[ "$(id -u)" != "0" ] && exec sudo "$0" "$@"
cd /SCRIPTS || exit 1

## definition:
LOGFILENAME="$(basename "$0")"
PATH="./:${PATH}"; export PATH

## integration
. ./LIB/system-baseconfig
. ./LIB/func_script-logging-handling
. ./LIB/func_apt-get-handling
. ./LIB/func_search-and-replace-handling

## -------------------------------------------------------------------------- ##
## FUNCTIONS:
## -------------------------------------------------------------------------- ##
## configure user
func_config_user(){
  local opt
  opt="--disabled-password --gecos \"\" --uid 1000"

  ## precondition
  if [ -d "/home/${USER}" ]; then
    func_echo "- USER: ${USER} exist"
  else
    func_echo "- Add USER: ${USER}"
    func_cmd_response "adduser ${USER} ${opt}"
  fi
}

## customize system files
func_customize_system_files(){
  local file search_pattern replace_pattern

  #file="/etc/passwd"; func_echo "- customize $file"
  #search_pattern="^${USER}:x:1000:1000:.*?:"
  #replace_pattern="${USER}:x:1000:1000:User ${USER}:"
  #func_perl_search_and_replace "${file}" "${search_pattern}" "${replace_pattern}"

  #file="/etc/shadow"; func_echo "- customize $file"
  #search_pattern="^root:\*"; replace_pattern="root:x"
  #func_perl_search_and_replace "${file}" "${search_pattern}" "${replace_pattern}"

  file="/etc/shadow"
  func_echo "- customize $file"
  func_echo "  - change user: $USER in /etc/shadow entry to 'no pw'"
  func_echo "    ('*' = 'no login', 'x' = 'no pw')"
  search_pattern="^${USER}:.*?:"; replace_pattern="${USER}:x:"
  func_perl_search_and_replace "${file}" "${search_pattern}" "${replace_pattern}"

  ## file="/etc/group"; func_echo "- customize $file"
  ## file="/etc/gshadow"; func_echo "- customize $file"
}

## -------------------------------------------------------------------------- ##
## MAIN:
## -------------------------------------------------------------------------- ##
## time measurement: start
main_start=$(date +%s)

## logging handling switched on
func_init_log_file "/info" "${LOGFILENAME}"

## -----------------------
## process install
func_echo_base_topic "Basic Configuration after debootstrap:"

## process install basical configurations
func_echo "### Configure 'Locales' by processing locale-gen"
func_cmd_response "locale-gen"

## process install user configurations
func_echo "### Configure 'Locales' by processing locale-gen"
func_config_user

## customize system files
func_echo "### Customize system files"
func_customize_system_files

## upgrade all packages currently installed on the system
func_echo "### Upgrade all packages currently installed on the system"
func_echo "- (depending on the installed base config)"
func_apt_get_update
func_apt_get_dist_upgrade

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
exit 0

