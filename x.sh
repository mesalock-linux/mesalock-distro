#!/bin/bash

set -xe

pkgrepo=$(pwd)/packages

ls $pkgrepo | parallel --ungroup -j8 ./mkpkg {}
