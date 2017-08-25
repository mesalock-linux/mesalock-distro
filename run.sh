#!/bin/bash
set -xe

WORKDIR=$(pwd)
ROOTFS=$WORKDIR/rootfs
SRC=$WORKDIR/src

# create directory
mkdir -p $ROOTFS
cd $ROOTFS
mkdir -p bin \
         dev/null \
         dev/pts \
         dev/shm \
         lib/x86_64-linux-gnu \
         lib64 \
         mnt \
         proc \
         root \
         sys \
         tmp

# copy librares and dynamic linker
cp /lib/x86_64-linux-gnu/{libc.so.6,libdl.so.2,libgcc_s.so.1,libm.so.6,libpthread.so.0,librt.so.1} $ROOTFS/lib/x86_64-linux-gnu/
cp /lib64/ld-linux-x86-64.so.2 $ROOTFS/lib64/

# start build & install rust binary
mkdir -p $SRC

# build & install ion
cd $SRC && git clone https://github.com/redox-os/ion.git
cd $SRC/ion
cargo update -p liner # make sure liner is updated regardless of Cargo.lock
cargo build --release
cp $SRC/ion/target/release/ion $ROOTFS/bin/

# build & install coreutils
cd $SRC && git clone https://github.com/uutils/coreutils.git
cd $SRC/coreutils 
wget https://gist.github.com/mssun/fbc3f9297ca585924e1ac4e3279074af/raw/755b6beae4880a790d199eefb657d2043deb122b/coreutils.patch
git apply coreutils.patch
make MULTICALL=y PREFIX=$ROOTFS install

# tar rootfs
tar cvfJ $WORKDIR/rootfs.tar.xz -C $ROOTFS .
