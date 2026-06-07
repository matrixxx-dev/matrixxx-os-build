#!/bin/bash

## ########################################################################## ##
## log file evaluation after build
## - check on errors
## - check on removed packages
##
## ########################################################################## ##
## includes
source ./init

## definitions
[ -n "$1" ] && TARGET_NAME="$1"     ## overwrite if desired
SCRIPT_PATH="$PWD"

## -------------------------------------------------------------------------- ##
## FUNCTIONS:
## -------------------------------------------------------------------------- ##
func_process(){ # arch="$1"
  local arch info_dir log_file_list
  arch="$1"
  echo "ARCHITECTURE: ${arch}"
  cd "${TARGET_NAME}/${arch}" || exit 1
  info_dir="info"

  readarray -t log_file_list < <(ls "./${info_dir}"/*.log 2>/dev/null)

  echo "Evaluation of directory: ${TARGET_NAME}/${arch}/${info_dir}"
  echo "Number of log files: ${#log_file_list[@]}"

  local file_errors file_removed #file_reinstalled
  file_errors="log-file-evaluation-errors.md"
  echo -n > "${file_errors}"
  file_removed="log-file-evaluation-removed.md"
  echo -n > "${file_removed}"
  for log_file in "${log_file_list[@]}"
  do
    echo "${log_file}"
    "${SCRIPT_PATH}"/perl/log-file-evaluation.pl \
      "${log_file}" "${file_errors}" "ERROR:" || exit 1
    "${SCRIPT_PATH}"/perl/log-file-evaluation.pl \
      "${log_file}" "${file_removed}" ", ([1-9][0-9]*) zu entfernen" || exit 1
  done

  func_gen_html_with_pandoc

  cd "${SCRIPT_PATH}" || exit 1
}

func_gen_html_with_pandoc(){
  local cmd
  if cmd=$(type -p pandoc-run.sh) && [ -x "${cmd}" ]; then
    echo "run ${cmd}:"
    [ -f "${file_errors}" ] && ${cmd} "${file_errors}" 2>/dev/null
    [ -f "${file_removed}" ] && ${cmd} "${file_removed}" 2>/dev/null
  elif cmd=$(type -p pandoc) && [ -x "${cmd}" ]; then
    echo "run ${cmd}:"
    [ -f "${file_errors}" ] \
      && ${cmd} -f markdown -t html5 "${file_errors}" -o "${file_errors}.html"
    [ -f "${file_removed}" ] \
      && ${cmd} -f markdown -t html5 "${file_removed}" -o "${file_removed}.html"
  fi
}

func_log_file_evaluation_process(){
  ## separation of possible architectures
  func_arch_process
}

## -------------------------------------------------------------------------- ##
## MAIN:
## -------------------------------------------------------------------------- ##
func_log_file_evaluation_process

## -------------------------------------------------------------------------- ##
## pause:
#echo "Press enter to continue..."; read -r

## ########################################################################## ##
exit 0
