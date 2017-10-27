#!/bin/bash

set -xe

pkgrepo=$(pwd)/packages

ls $pkgrepo | parallel -j10 ./mkpkg
