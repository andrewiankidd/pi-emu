#!/bin/bash
set -e

## buster
# DOWNLOAD_IMAGE=raspios_lite_armhf-2021-05-28
## bullseye
# DOWNLOAD_IMAGE=raspios_lite_armhf-2023-05-03
## bookworm
DOWNLOAD_IMAGE=raspios_lite_armhf-2023-12-11
## latest
# DOWNLOAD_IMAGE=latest

DOWNLOAD_PAGE=https://downloads.raspberrypi.org/raspios_lite_armhf/images/
DOWNLOAD_LINK=$DOWNLOAD_PAGE$DOWNLOAD_IMAGE

if [[ "$DOWNLOAD_IMAGE" == "latest" ]]; then
    # get all links on page
    LINKS=$(curl -f -L $DOWNLOAD_PAGE | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d')
    LINKSARR=( $LINKS )

    # get most recent link
    MOST_RECENT_IMAGE_NAME=${LINKSARR[-1]%/}
    DOWNLOAD_LINK=$DOWNLOAD_PAGE$MOST_RECENT_IMAGE_NAME
fi

# download latest image
wget $DOWNLOAD_LINK -R html -nc -P build -l 1 -c -e robots=off --no-check-certificate -w 2 -r -nH --cut-dirs=3 -np -R "index.html*" -A .xz,.zip