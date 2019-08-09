#!/bin/bash

#    Utilities required
#    Bash-4.0
#    Binutils-2.20
#    Bzip2-1.0.5
#    Coreutils-8.1
#    Diffutils-3.0
#    Findutils-4.4.0
#    Gawk-3.1
#    GCC-4.4
#    Glibc-2.11
#    Grep-2.6
#    Gzip-1.3
#    M4-1.4.16
#    Make-3.81
#    ncurses5
#    Patch-2.6
#    Sed-4.2.1
#    Sudo-1.7.4p4
#    Tar-1.23
#    Texinfo-4.13

function evaluate_corresponding_version(){
  local current="$1"
  local required="$2"

  if [[ "$(printf '%s\n' "${required}" "${current}" | sort -V | head -n1)" = "$required" ]]; then
    return 0
   else
    return 1
   fi
}
function get_versions(){
	binutils_version=$(ld --version | head -n1 | cut -d" " -f3-)
	bzip2_version=$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-)
	coreutils_version=$(chown --version | head -n1 | cut -d")" -f2)
	glibc_version=$(ldd "$(which "${SHELL}")" | grep libc.so | cut -d ' ' -f 3 \
		| "${SHELL}" | head -n 1 | cut -d ' ' -f 1-10)
	ncurses5_version=$(echo "#include <ncurses.h>" | gcc -E - > /dev/null)
	sudo_version=$(sudo -V | head -n1)

	diffutils_version=$(diff --version | head -n1)
	findutils_version=$(find --version | head -n1)
	gawk_version=$(gawk --version | head -n1)
	gcc_version=$(gcc --version | head -n1)
	grep_version=$(grep --version | head -n1)
	gzip_version=$(gzip --version | head -n1)
	m4_version=$(m4 --version | head -n1)
	make_version=$(make --version | head -n1)
	patch_version=$(patch --version | head -n1)
	tar_version=$(tar --version | head -n1)
	make_info_version=$(makeinfo --version | head -n1)
	sed_version=$(sed --version | head -n1)

	all_versions=$( cat << EOF
	binutils_version=${binutils_version}
	bzip2_version=${bzip2_version}
	coreutils_version=${coreutils_version}
	glibc_version=${glibc_version}
	ncurses5_version=${ncurses5_version}
	sudo_version=${sudo_version}
	
	diffutils_version=${diffutils_version}
	findutils_version=${findutils_version}
	gawk_version=${gawk_version}
	gcc_version=${gcc_version}
	grep_version=${grep_version}
	gzip_version=${gzip_version}
	m4_version=${m4_version}
	make_version=${make_version}
	patch_version=${patch_version}
	tar_version=${tar_version}
	make_info_version=${make_info_version}
	sed_version=${sed_version}
	EOF)
	echo "${all_versions}"
}

bash_version=$(bash --version | head -n1 | cut -d" " -f2-4)
echo "${bash_version}"
get_versions
