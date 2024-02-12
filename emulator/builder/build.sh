#!/bin/bash
clear
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
parentDirectory=$(dirname $SCRIPT_DIR)
cd $parentDirectory

echo "downloading image"
/bin/bash $parentDirectory/builder/scripts/download-image.sh

echo "processing image"
/bin/bash $parentDirectory/builder/scripts/process-image.sh

echo "exporting build"
/bin/bash $parentDirectory/builder/scripts/export-build.sh