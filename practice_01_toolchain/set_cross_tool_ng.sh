#!/bin/bash

# Based on http://crosstool-ng.github.io/docs/build/
VERSION="1.24.0"

function install_ct_ng(){

  echo -n "Do you want to install required ubuntu packages? [y/n]: "
  read -n 1 ans
  
  if [[ "${ans^^}" == 'Y' ]]; then
    sudo apt-get install -y gcc g++ gperf \
      bison flex texinfo help2man make \
      libncurses5-dev libncursesw5-dev \
      python3-dev autoconf automake libtool \
      libtool-bin gawk wget bzip2 xz-utils unzip \
      patch libstdc++6 cvs
  fi

  mkdir -p ct-ng_setup
  cd ct-ng_setup || exit 1
  
  mkdir -p sources
  cd sources || exit 1
  # First, download the tarball:
  wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-"${VERSION}".tar.bz2
  tar -xf crosstool-ng-"${VERSION}".tar.bz2 && rm crosstool-ng-"${VERSION}".tar.bz2
  
  # Requirements
  # https://github.com/crosstool-ng/crosstool-ng.git -> 
  # crosstool-ng/testing/docker/ubuntu18.04/Dockerfile

  # RUN wget -O /sbin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64
  # RUN chmod a+x /sbin/dumb-init
  # RUN echo 'export PATH=/opt/ctng/bin:$PATH' >> /etc/profile
  # ENTRYPOINT [ "/sbin/dumb-init", "--" ]
  
  cd crosstool-ng-"${VERSION}" || exit 1 
  
  ./configure --enable-local
   make
  
   if ! ./ct-ng --help ;then
     echo "ct-ng was not successfully installed"
     exit 1
   fi
   
#   ./configure --prefix=/usr
#   make
#   make DESTDIR=/packaging/place install
 
   ./ct-ng menuconfig
}

install_ct_ng
