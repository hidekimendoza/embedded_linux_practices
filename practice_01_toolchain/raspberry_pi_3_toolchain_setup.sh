#!/bin/bash

#    Bash-4.0
#    Binutils-2.20
#    Bzip2-1.0.5
#    Coreutils-8.1
#    Glibc-2.11
#    ncurses5

#    Diffutils-3.0
#    Findutils-4.4.0
#    Gawk-3.1
#    GCC-4.4
#    Grep-2.6
#    Gzip-1.3
#    M4-1.4.16
#    Make-3.81
#    Patch-2.6
#    Sudo-1.7.4p4
#    Tar-1.23
#    Texinfo-4.13
#    Sed-4.2.1

declare -A standard_tools { 
[bash]="4.0"
[binutils]="2.20"
[bzip2]="1.0.5"
[coreutils]="8.1"
[diffutils]="3.0"
[findutils]="4.4.0"
[gawk]="3.1"
[gcc]="4.4"
[glibc]="2.11"
[grep]="2.6"
[gzip]="1.3"
[m4]="1.4.16"
[make]="3.81"
[makeinfo]="4.13"
[ncurses]="5"
[patch]="2.6"
[tar]="1.23"
[sed]="4.2.1"
[sudo]="1.7.4p4"
}

function is_installed(){
  local tool="$1"

  is_installed=$(hash "${tool}" 1>/dev/null)
  echo "${is_installed}"
}

function evaluate_corresponding_version(){
  local current="$1"
  local required="$2"

  if [[ "$(printf '%s\n' "${required}" "${current}" | sort -V | head -n1)" == "$required" ]]; then
    return 0
   else
    return 1
   fi
}

function manage_version_installed(){
  local util_name="$1"
  local expected_version="$2"

  if $(is_installed "${util_name}"); then
    if $(evaluate_corresponding_version "${util_name}" "${expected_version}") ; then
      return 0
    else
      return 1
    fi
  else
    return 2
  fi
}

function get_version(){
  case ${app} in
  "bash")
    echo "$(bash --version | head -n1 | cut -d" " -f2-4)" 
  "binutils")
    echo "$(ld --version | head -n1 | cut -d" " -f3-)"
    ;;
  "bzip")
    echo "$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-)"
    ;;
  "coreutils")
    echo "$(chown --version | head -n1 | cut -d")" -f2)"
    ;;
  "glibc")
    echo "$(ldd "$(which "${SHELL}")" | grep libc.so | cut -d ' ' -f 3 \
  	  | "${SHELL}" | head -n 1 | cut -d ' ' -f 1-10)"
    ;;
  "ncurses")
    echo "$(echo "#include <ncurses.h>" | gcc -E - > /dev/null)"
    ;;
  *)
    echo "$(${app} --version | head -n1)"
  esac
}
