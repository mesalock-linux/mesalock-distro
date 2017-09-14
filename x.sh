#!/bin/bash

set -xe

export MAKEFLAGS=-j$(nproc)

rootfs=$(pwd)/rootfs
dockerdir=$(pwd)/docker

packages=(filesystem glibc ion coreutils ripgrep fd-find tzdata)

rm -rf rootfs
for p in ${packages[@]}; do
  ./mkpkg $p
done

mkdir -p $rootfs
for p in ${packages[@]}; do
  tar xvfJ build/out/$p.tar.xz -C rootfs
done

install -D -m755 /lib/x86_64-linux-gnu/libgcc_s.so.1 -t $rootfs/usr/lib/

tar cvfJ $dockerdir/rootfs.tar.xz -C $rootfs .
