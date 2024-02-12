#!/bin/bash
set -e

mkdir -p ./images
cp -r ./build/*/ ./images
rm -rf ./build/