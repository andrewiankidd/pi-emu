#!/bin/bash
set -e

for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)

   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"

   export "$KEY"="$VALUE"
done

# get script params if defined, default values if not
MACHINE=${MACHINE:="raspi3b"}
CPU=${CPU:="cortex-a53"}
MEM=${MEM:="1G"}
DTB=${DTB:="bcm2710-rpi-3-b.dtb"}
KERNEL=${KERNEL:="kernel8.img"}
IMAGE=${IMAGE:="2023-12-11-raspios-bookworm-armhf-lite"}

# Check if image exists locally
if [ ! -e "$PWD/emulator/images/$Image" ]; then
    echo "Warning: Image '$Image' not found! Downloading."
    "$PWD/emulator/builder/build.sh" "$Image"
fi

# Run Qemu
qemu-system-aarch64 \
    -machine "$MACHINE" \
    -cpu "$CPU" \
    -m "$MEM" \
    -smp 4 \
    -drive "file=$PWD/emulator/images/$IMAGE/image.img,if=sd,index=0,media=disk,format=raw,id=disk0" \
    -dtb "$PWD/emulator/images/$IMAGE/$DTB" \
    -kernel "$PWD/emulator/images/$IMAGE/$KERNEL" \
    -append 'rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1' \
    -serial mon:stdio \
    -usb \
    -device usb-mouse \
    -device usb-kbd \
    -device usb-net,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::5555-:22 \
    -no-reboot