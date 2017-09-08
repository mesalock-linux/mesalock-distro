#!/bin/bash

set -xe

export MAKEFLAGS=-j$(nproc)
BUILD_DIR=$(pwd)/build
PACKAGES_DIR=$(pwd)/packages
DOCKER_DIR=$(pwd)/docker
mkdir -p $BUILD_DIR

ROOTFS=$(pwd)/rootfs

# create directory
mkdir -p $ROOTFS
mkdir -p $ROOTFS/{bin,dev/{null,pts,shm},lib,lib64,mnt,proc,root,sys,tmp}

# build and install pacakges

PACKAGES=(glibc ion coreutils ripgrep)

for p in ${PACKAGES[@]}; do
  source $PACKAGES_DIR/$p/build.sh
  WORK_DIR=$BUILD_DIR/$p
  mkdir -p $WORK_DIR
  cd $WORK_DIR
  prepare
  cd $WORK_DIR
  configure
  cd $WORK_DIR
  compile
  cd $WORK_DIR
  install
done

# libgcc is not compiled from source right now
cp /lib/x86_64-linux-gnu/libgcc_s.so.1 $ROOTFS/lib/

tar cvfJ $DOCKER_DIR/rootfs.tar.xz -C $ROOTFS .
