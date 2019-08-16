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

function is_installed(){
  local tool="$1"
 case ${tool} in
  "binutils")
    tool='ld'
    ;;
  "texinfo")
    tool='chown'
    ;;
  "coreutils")
    tool='chown'
    ;;
  "glibc")
    return 0
    ;;
  "ncurses")
    return 0
    ;;
  esac
  hash "${tool}" 2>/dev/null
  return $?
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

function get_version(){
  local app="$1"
  local app_version
  case ${app} in
  "bash")
    app_version=$(bash --version | head -n1 | sed -n 's/.*\s\([1-9]\+\(\.[0-9]\+\)\+\).*/\1/p')
    ;;
  "binutils")
    app_version=$(ld --version | head -n1 | sed -n 's/.*\s\([1-9]\+\(\.[0-9]\+\)\+\).*/\1/p')
    ;;
  "bzip2")
    app_version=$( bzip2 --version 2>&1 | head -n1 | sed -n 's/.*\s\([1-9]\+\(\.[0-9]\+\)\+\).*/\1/p')
    ;;
  "coreutils")
    app_version=$(chown --version | head -n1 | sed -n 's/.*\s\([1-9]\+\(\.[0-9]\+\)\+\).*/\1/p')
    ;;
  "glibc")
    app_version=$(ldd "$(which "${SHELL}")" | grep libc.so | cut -d ' ' -f 3 \
      | "${SHELL}" | head -n 1 | sed -n 's/.*\s\([1-9]\+\(\.[0-9]\+\)\+\).*/\1/p')
    ;;
  "ncurses")
    app_version=$(echo "#include <ncurses.h>" | gcc -E - > /dev/null)
    if ! [[ ! "${$?}" ]] ;then
      app_version=5
    fi
    ;;
  *)
    app_version=$(${app} --version | head -n1 | sed -n 's/.*\s\([1-9]\+\(\.[0-9]\+\)\+\).*/\1/p')
  esac
  echo "${app_version}"
}

function manage_version_installed(){
  local util_name="$1"
  local expected_version="$2"

  if is_installed "${util_name}"; then
    current_version=$(get_version "${util_name}")
    if evaluate_corresponding_version "${current_version}" "${expected_version}" ; then
      return 0
    else
      echo "${util_name} need upgrade current version is: ${current_version} \
and expected is ${expected_version}" >&2
      return 1
    fi
  else
    echo "${util_name} tool is not installed" >&2
    return 2
  fi
}

function update_tool(){
  local app="$1"
  case ${app} in
  *)
    sudo apt-get install "${app}"
  esac
}

manage_version_installed 'bash' '4.0'

declare -A standard_tools=(
['binutils']="2.20"
['bzip2']="1.0.5"
['coreutils']="8.1"
['diff']="3.0"
['find']="4.4.0"
['gawk']="3.1"
['gcc']="4.4"
['glibc']="2.11"
['grep']="2.6"
['gzip']="1.3"
['m4']="1.4.16"
['make']="3.81"
['makeinfo']="4.13"
['ncurses']="5"
['patch']="2.6"
['tar']="1.23"
['sed']="4.2.1"
['sudo']="1.7.4p4"
)
tool_missing=false
for tool in "${!standard_tools[@]}"; do
  expected_version=${standard_tools[$tool]}
  manage_version_installed "${tool}" "${expected_version}"
  if [[ $? != 0 ]] ; then
    tool_missing=true
  fi
done

if [[ "${tool_missing}" == "false" ]] ; then
  echo 'All tools are installed'
  exit 0
else
  echo 'Tools need to be installed' >&2
  exit 1
fi
