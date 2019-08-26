# ubuntu docker as base
FROM ubuntu:18.04
LABEL version="1.1"
LABEL description="tools for cpp development/test"
RUN apt-get update && apt-get install -y \
    wget \
    make \
    sed \
    m4 \
    patch \
    gawk \
    gcc \
    binutils \
    libncurses5-dev \
    libncursesw5-dev \
    texinfo \
    g++ \
  && rm -rf var/lib/apt/lists/*

# Set workspace dir
RUN mkdir /usr/src/workspace
RUN mkdir /usr/src/output
WORKDIR /usr/src/workspace
VOLUME /usr/src/workspace

