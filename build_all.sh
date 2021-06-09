#!/bin/bash
set -e

./build.sh base
./build.sh cuda
./build.sh rust
./build.sh tectonic
