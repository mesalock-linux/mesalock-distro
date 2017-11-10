#!/bin/bash

set -xe

pkgrepo=$(pwd)/packages

ls $pkgrepo | parallel --ungroup $1 ./mkpkg {}
