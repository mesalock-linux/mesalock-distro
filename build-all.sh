#!/bin/bash

for pkg in `find packages -name "build.yml"`; do
    ./mkpkg/target/release/mkpkg build $pkg || exit 1
done
