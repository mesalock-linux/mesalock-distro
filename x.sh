#!/bin/bash

set -xe

export MAKEFLAGS=-j$(nproc)

rootfs=$(pwd)/rootfs
dockerdir=$(pwd)/docker

packages=(filesystem \
          glibc \
          ion-shell \
          uutils \
          ripgrep \
          fd-find \
          tzdata \
          xi-core \
          xi-tui \
          findutils \
          tokei \
          brotli \
          micro)

for p in ${packages[@]}; do
  ./mkpkg $p
done

rm -rf $rootfs
mkdir -p $rootfs
for p in ${packages[@]}; do
  tar xvfJ build/out/$p.tar.xz -C rootfs &
done
wait

install -D -m755 /lib/x86_64-linux-gnu/libgcc_s.so.1 -t $rootfs/usr/lib/

tar cvfJ $dockerdir/rootfs.tar.xz -C $rootfs .
