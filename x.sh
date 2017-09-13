#!/bin/bash

set -xe

export MAKEFLAGS=-j$(nproc)

rootfs=$(pwd)/rootfs
dockerdir=$(pwd)/docker
rm -rf rootfs

packages=(filesystem glibc ion coreutils ripgrep fd-find)

for p in ${packages[@]}; do
  ./mkpkg packages/$p/BUILD
done

mkdir -p $rootfs
for p in ${packages[@]}; do
  tar xvfJ build/out/$p.tar.xz -C rootfs
done

cp /lib/x86_64-linux-gnu/libgcc_s.so.1 $rootfs/usr/lib/

tar cvfJ $dockerdir/rootfs.tar.xz -C $rootfs .
