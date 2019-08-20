#!/bin/bash


function download_tools(){
# Download tools
  if [[ ! -d sources  ]]; then
    mkdir sources
  fi
  
  cd sources || return
  
  wget http://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.xz
  tar -xf binutils-2.32.tar.xz && rm binutils-2.32.tar.xz
  
  wget https://busybox.net/downloads/busybox-1.31.0.tar.bz2
  tar -xf busybox-1.31.0.tar.bz2 && rm busybox-1.31.0.tar.bz2
  
  wget https://gcc.gnu.org/pub/gcc/releases/gcc-8.3.0/gcc-8.3.0.tar.xz
  tar -xf gcc-8.3.0.tar.xz && rm gcc-8.3.0.tar.xz
  
  wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.lz
  tar -xf gmp-6.1.2.tar.lz && rm gmp-6.1.2.tar.lz
  
  wget http://sethwklein.net/iana-etc-2.30.tar.bz2
  tar -xf iana-etc-2.30.tar.bz2 && rm iana-etc-2.30.tar.bz2
  
  wget http://patches.clfs.org/embedded-dev/iana-etc-2.30-update-2.patch
  tar -xf iana-etc-2.30-update-2.patch rm iana-etc-2.30-update-2.patch
  
  wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.19.tar.xz
  tar -xf linux-4.19.tar.xz && rm linux-4.19.tar.xz
  
  wget https://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz
  tar -xf mpc-1.0.3.tar.gz && rm mpc-1.0.3.tar.gz
  
  wget https://ftp.gnu.org/gnu/mpfr/mpfr-4.0.2.tar.xz
  tar -xf mpfr-4.0.2.tar.xz && rm mpfr-4.0.2.tar.xz
  
  wget http://www.musl-libc.org/releases/musl-1.1.23.tar.gz
  tar -xf musl-1.1.23.tar.gz && rm musl-1.1.23.tar.gz
  
  cd - || return
}

# set +h
# umask 022
CLFS=/mnt/clfs
LC_ALL=POSIX
# PATH=${CLFS}/cross-tools/bin:/bin:/usr/bin
# export CLFS LC_ALL PATH

unset CFLAGS

# hard, softfp, or soft
CLFS_FLOAT='hard'

# fpa 	fpe2 	fpe3 	maverick
# vfp 	vfpv3 	vfpv3-fp16 	vfpv3-d16
# vfpv3-d16-fp16 	vfpv3xd 	vfpv3xd-fp16 	neon
# neon-fp16 	vfpv4 	vfpv4-d16 	fpv4-sp-d16
# neon-vfpv4
CLFS_FPU='neon-vfpv4'

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

mkdir -p ${CLFS}/cross-tools/${CLFS_TARGET}
ln -sfv . ${CLFS}/cross-tools/${CLFS_TARGET}/usr

function install_sanitized_headers(){
  cd sources/linux-4.19 || return 1
  make mrproper
  make ARCH=${CLFS_ARCH} headers_check
  make ARCH=${CLFS_ARCH} INSTALL_HDR_PATH=${CLFS}/cross-tools/${CLFS_TARGET} headers_install
  cd - || return 1

  if [[ ! -f "${CLFS}/cross-tools/${CLFS_TARGET}/include/asm"  ]];then
    echo "error! sanitized headers haven't been installed"
    exit 1
  fi
}
