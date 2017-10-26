#!/bin/bash

set -xe

pkgrepo=$(pwd)/packages

for p in `ls $pkgrepo`; do
  echo "[+] Building $p"
  ./mkpkg $p
done
