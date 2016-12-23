FROM ubuntu:14.04

MAINTAINER andy@betacode.io

# Install prerequisites to compile the libraries
RUN apt-get update -qq && \
    apt-get install -y wget git libtool pkg-config \
    build-essential autoconf automake libzmq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install stable version of libsodium - a crypto library
RUN cd /tmp && \
    git clone git://github.com/jedisct1/libsodium.git && \
    cd libsodium && git checkout stable && \
    ./autogen.sh && \
    ./configure && make check && make install && ldconfig

# Download specific version of zeromq and install
RUN cd /opt && \
    wget https://github.com/zeromq/libzmq/releases/download/v${ZEROMQ_VERSION:-4.2.0}/zeromq-${ZEROMQ_VERSION:-4.2.0}.tar.gz && \
    tar -xzf zeromq-${ZEROMQ_VERSION:-4.2.0}.tar.gz && cd zeromq-${ZEROMQ_VERSION:-4.2.0} && \
    ./autogen.sh && ./configure && make && make install

RUN rm /opt/zeromq-${ZEROMQ_VERSION:-4.2.0}* -rf && rm /tmp/* -rf
