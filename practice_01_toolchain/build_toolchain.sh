#!/bin/bash


# default directory permissions are 755 and default file permissions are 644.
# umask 022
# exec env -i HOME=${HOME} TERM=${TERM} PS1='\u:\w\$ '
CLFS=/usr/src/output
CLFS_SRC_DIR="${CLFS}/sources"
LC_ALL=POSIX
PATH=${CLFS}/cross-tools/bin:/bin:/usr/bin
# export CLFS LC_ALL PATH

unset CFLAGS

# hard, softfp, or soft
CLFS_FLOAT='hard'

# fpa 	fpe2 	fpe3 	maverick
# vfp 	vfpv3 	vfpv3-fp16 	vfpv3-d16
# vfpv3-d16-fp16 	vfpv3xd 	vfpv3xd-fp16 	neon
# neon-fp16 	vfpv4 	vfpv4-d16 	fpv4-sp-d16
# neon-vfpv4
CLFS_FPU='neon-fp-armv8'
CLFS_HOST=$( echo "${MACHTYPE}" | sed "s/-[^-]*/-cross/" )
CLFS_ARCH=arm

# soft or softfp 	arm-linux-musleabi
# hard 	arm-linux-musleabihf
if [[ "${CLFS_FLOAT}" == 'hard'  ]]; then
  CLFS_TARGET='arm-linux-musleabihf'
else
  CLFS_TARGET='arm-linux-musleabihf'
fi


# armv4t 	armv5 	armv5t 	armv5te
# armv6 	armv6j 	armv6t2 	armv6z
# armv6zk 	armv6-m 	armv7 	armv7-a
# armv7-r 	armv7-m
CLFS_ARM_ARCH='armv8-a'

function get_tool_src_dir(){
  local util="$1"
  local directory="$2"
  local util_directory

  util_directory=$( find "${directory}" -maxdepth 1 -name "*${util}*"  -type d )
  if [[ -n "${util_directory=}"  ]]; then
    # echo "${util_directory##*/}"
    echo "${util_directory}"
    return 0
  fi
  return 1
}

function download_tools(){
# Download tools
  local current_path
  local bin_utils_ver="2.32"
  local busybox_ver="1.31.0"
  local gcc_ver="8.3.0"
  local linux_kernel_ver="4.19"
  local musl_ver="1.1.23"

#  local bin_utils_ver="2.27"
#  local busybox_ver="1.24.2"
#  local gcc_ver="7.4.0"
#  local gcc_ver="6.2.0"
#  local linux_kernel_ver="4.9.22"
#  local musl_ver="1.1.16"

  current_path=$( pwd )
  if [[ ! -d  "${CLFS_SRC_DIR}" ]]; then
    mkdir -p "${CLFS_SRC_DIR}"
  fi

  cd "${CLFS_SRC_DIR}" || return 1

  if [[ ! -d  "binutils-${bin_utils_ver}" ]];then
    wget http://ftp.gnu.org/gnu/binutils/"binutils-${bin_utils_ver}".tar.gz
    tar -xf "binutils-${bin_utils_ver}".tar.gz \
      && rm "binutils-${bin_utils_ver}".tar.gz
  fi

  if [[ ! -d  "busybox-${busybox_ver}" ]];then
    wget https://busybox.net/downloads/"busybox-${busybox_ver}".tar.bz2
    tar -xf "busybox-${busybox_ver}".tar.bz2 \
      && rm "busybox-${busybox_ver}".tar.bz2
  fi

  if [[ ! -d  "gcc-${gcc_ver}" ]];then
    wget https://gcc.gnu.org/pub/gcc/releases/"gcc-${gcc_ver}"/"gcc-${gcc_ver}".tar.gz
    tar -xf "gcc-${gcc_ver}".tar.gz \
      && rm "gcc-${gcc_ver}".tar.gz

    cd "gcc-${gcc_ver}" || exit 1
    bash contrib/download_prerequisites
    cd "${CLFS_SRC_DIR}" || exit 1
  fi

#  if [[ ! -d  mpc-1.0.3 ]];then
#    wget https://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz
#    tar -xf mpc-1.0.3.tar.gz && rm mpc-1.0.3.tar.gz
#  fi
#
#  if [[ ! -d  mpfr-4.0.2 ]];then
#    wget https://ftp.gnu.org/gnu/mpfr/mpfr-4.0.2.tar.gz
#    tar -xf mpfr-4.0.2.tar.gz && rm mpfr-4.0.2.tar.gz
#  fi
#
#  if [[ ! -d gmp-6.1.2 ]];then
#    wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2
#    tar -xf gmp-6.1.2.tar.bz2 && rm gmp-6.1.2.tar.bz2
#  fi

  if [[ ! -d  iana-etc-2.30 ]];then
    wget http://sethwklein.net/iana-etc-2.30.tar.bz2
    tar -xf iana-etc-2.30.tar.bz2 && rm iana-etc-2.30.tar.bz2
  fi

  if [[ ! -f iana-etc-2.30-update-2.patch ]];then
    wget http://patches.clfs.org/embedded-dev/iana-etc-2.30-update-2.patch
  fi

  if [[ ! -d  "linux-${linux_kernel_ver}" ]];then
    # TODO path currently pointing to v4.x only
    wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/"linux-${linux_kernel_ver}".tar.gz
    tar -xf "linux-${linux_kernel_ver}".tar.gz && rm "linux-${linux_kernel_ver}".tar.gz
  fi

  if [[ ! -d "musl-${musl_ver}" ]];then
    wget http://www.musl-libc.org/releases/"musl-${musl_ver}".tar.gz
    tar -xf "musl-${musl_ver}".tar.gz && rm "musl-${musl_ver}".tar.gz
  fi

#  ln -sf "${CLFS_SRC_DIR}/mpc-1.0.3" mpc
#  ln -sf "${CLFS_SRC_DIR}/mpfr-4.0.2" mpfr
#  ln -sf "${CLFS_SRC_DIR}/gmp-6.1.2" gmp

  cd "${current_path}" || return 1
}

function install_sanitized_headers(){
  local linux_kernel_source_dir

  if [[ ! -d "${CLFS}/cross-tools/${CLFS_TARGET}/include/asm"  ]];then
    linux_kernel_source_dir=$( get_tool_src_dir "linux" "${CLFS_SRC_DIR}" )
    if [[ -z "${linux_kernel_source_dir}" ]];then
      return 1
    fi

    cd "${linux_kernel_source_dir}" || return 1
    make mrproper
    make ARCH=${CLFS_ARCH} headers_check
    make ARCH=${CLFS_ARCH} INSTALL_HDR_PATH=${CLFS}/cross-tools/${CLFS_TARGET} headers_install
    cd - || return 1

    if [[ ! -d "${CLFS}/cross-tools/${CLFS_TARGET}/include/asm"  ]];then
      echo 'error! sanitized headers have not been installed' >&2
      exit 1
    fi
  else
    return 0
  fi
}

function install_binutils(){
  local configure_step
  local binutils_source_dir

  if [[ ! -e "${CLFS}/cross-tools/bin/arm-linux-musleabihf-addr2line" ]]; then
    binutils_source_dir=$( get_tool_src_dir "binutils" "${CLFS_SRC_DIR}" )
    if [[ -z "${binutils_source_dir}" ]];then
      return 1
    fi

    mkdir -p "${CLFS}/binutils-build"
    cd "${CLFS}/binutils-build" || return 1
    configure_step=$( "${binutils_source_dir}"/configure \
     --prefix=${CLFS}/cross-tools \
     --target=${CLFS_TARGET} \
     --with-sysroot=${CLFS}/cross-tools/${CLFS_TARGET} \
     --disable-nls \
     --disable-multilib )

    # This checks the host environment and makes sure all the necessary tools are available to compile Binutils.
    if ! make configure-host; then
      echo 'not all required tools are installed to compile binutils' >&2
      exit 1
    fi
    make
    make install
  fi
}

function install_gcc_first_step(){
  local configure_step
  local gcc_source_files
  local mpfr_src_dir

  if [[ ! -e  ${CLFS}/cross-tools/bin/"${CLFS_TARGET}"-gcc ]]; then
    mkdir -p "${CLFS}/gcc-build"
    cd "${CLFS}/gcc-build" || return 1
    gcc_source_files=$( get_tool_src_dir "gcc" "${CLFS_SRC_DIR}" )
    if [[ -z "${gcc_source_files}" ]];then
      return 1
    fi

    # Get mpfr/src directory since their location is different according
    mpfr_src_dir=$( find -L "${gcc_source_files}"/mpfr -name isnum.c )
    mpfr_src_dir="${mpfr_src_dir/#$gcc_source_files\/mpfr}"
    mpfr_src_dir="${mpfr_src_dir%\/isnum.c}"

    # to the version
    mkdir -p "${CLFS}/gcc-build"
    cd "${CLFS}/gcc-build" || return 1
    configure_step=$( ${gcc_source_files}/configure \
    --prefix=${CLFS}/cross-tools \
    --build=${CLFS_HOST} \
    --host=${CLFS_HOST} \
    --target=${CLFS_TARGET} \
    --with-sysroot=${CLFS}/cross-tools/${CLFS_TARGET} \
    --disable-nls \
    --disable-shared \
    --without-headers \
    --with-newlib \
    --disable-decimal-float \
    --disable-libgomp \
    --disable-libmudflap \
    --disable-libssp \
    --disable-libatomic \
    --disable-libquadmath \
    --disable-threads \
    --enable-languages=c,c++ \
    --disable-multilib \
    --with-mpfr-include=${gcc_source_files}/mpfr"${mpfr_src_dir}" \
    --with-mpfr-lib=${CLFS}/gcc-build/mpfr"${mpfr_src_dir}"/.libs \
    --with-arch=${CLFS_ARM_ARCH} \
    --with-float=${CLFS_FLOAT} \
    --with-fpu=${CLFS_FPU} )
    make all-gcc all-target-libgcc
    make install-gcc install-target-libgcc
    cd - || return 1
  fi
  return 0
}

function compile_libc_musl(){
  local configure_step
  local musl_source_dir
  local mpfr_src_dir

  if [[ ! -e ${CLFS}/cross-tools/${CLFS_TARGET}/lib/libc.a ]]; then
    musl_source_dir=$( get_tool_src_dir "musl" "${CLFS_SRC_DIR}" )
    if [[ -z "${musl_source_dir}" ]];then
      return 1
    fi

    configure_step=$( ${musl_source_dir}/configure \
    CROSS_COMPILE=${CLFS_TARGET}- \
    --prefix=/ \
    --target=${CLFS_TARGET} )
    make
    DESTDIR=${CLFS}/cross-tools/${CLFS_TARGET} make install
  fi
}

function install_gcc_second_step(){
  local configure_step
  local gcc_source_files

  mkdir -p "${CLFS}/gcc-build"
  cd "${CLFS}/gcc-build" || return 1
  gcc_source_files=$( get_tool_src_dir "gcc" "${CLFS_SRC_DIR}" )
  if [[ -z "${gcc_source_files}" ]];then
    return 1
  fi

  # Get mpfr/src directory since their location is different according
  mpfr_src_dir=$( find -L "${gcc_source_files}"/mpfr -name isnum.c )
  mpfr_src_dir="${mpfr_src_dir/#$gcc_source_files\/mpfr}"
  mpfr_src_dir="${mpfr_src_dir%\/isnum.c}"

  configure_step=$( ${gcc_source_files}/configure \
  --prefix=${CLFS}/cross-tools \
  --build=${CLFS_HOST} \
  --host=${CLFS_HOST} \
  --target=${CLFS_TARGET} \
  --with-sysroot=${CLFS}/cross-tools/${CLFS_TARGET} \
  --disable-nls \
  --enable-languages=c,c++ \
  --enable-c99 \
  --enable-long-long \
  --disable-libmudflap \
  --disable-multilib \
  --with-mpfr-include=${gcc_source_files}/mpfr"${mpfr_src_dir}" \
  --with-mpfr-lib=${CLFS}/gcc-build/mpfr"${mpfr_src_dir}"/.libs \
  --with-arch=${CLFS_ARM_ARCH} \
  --with-float=${CLFS_FLOAT} \
  --with-fpu=${CLFS_FPU} )

  make
  make install
}

mkdir -p ${CLFS}/cross-tools/${CLFS_TARGET}

ln -sf . ${CLFS}/cross-tools/${CLFS_TARGET}/usr

download_tools
install_sanitized_headers
install_binutils
install_gcc_first_step
compile_libc_musl
install_gcc_second_step

