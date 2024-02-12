#!/bin/bash
set -e

# find image file
ARCHIVE_FILE=$(find ./build -maxdepth 1 -type f \( -name "*.zip" -o -name "*.xz" \) | xargs ls -1S | head -n 1)

if [[ "$ARCHIVE_FILE" == *.zip ]]; then
    echo "Extracting archive: unzip "$ARCHIVE_FILE""
    unzip "$ARCHIVE_FILE" -d ./build
else
    echo "Extracting archive: unxz -f -k $ARCHIVE_FILE"
    unxz -f -k "$ARCHIVE_FILE"
fi

# find extracted image
EXTRACTED_IMAGE_FILE=$(find ./build -maxdepth 1 -type f -name *.img | xargs ls -1S | head -n 1)
EXTRACTED_IMAGE_DIR=$(dirname "$EXTRACTED_IMAGE_FILE")
EXTRACTED_IMAGE_NAME_WITH_EXTENSION=$(basename "$EXTRACTED_IMAGE_FILE")
EXTRACTED_IMAGE_NAME="${EXTRACTED_IMAGE_NAME_WITH_EXTENSION%.*}"

# create target dir
TARGET_IMAGE_DIR=$EXTRACTED_IMAGE_DIR/$EXTRACTED_IMAGE_NAME
echo "Creating image directory: mkdir -p $TARGET_IMAGE_DIR"
mkdir -p $TARGET_IMAGE_DIR

# set target paths
TARGET_IMAGE_FILE=$TARGET_IMAGE_DIR/image.img
TARGET_KERNEL_FILE=$TARGET_IMAGE_DIR/kernel.img
TARGET_DTB_FILE=$TARGET_IMAGE_DIR/treeblob.dtb

echo "Renaming Image: mv $EXTRACTED_IMAGE_FILE $TARGET_IMAGE_FILE"
mv $EXTRACTED_IMAGE_FILE $TARGET_IMAGE_FILE

echo "Getting image info: fdisk -l $TARGET_IMAGE_FILE"
SECTORS=$(fdisk -l $TARGET_IMAGE_FILE)
START_ADDRESS=$(awk 'NR == 9 {print $2}' <<< $SECTORS)
SECTOR_SIZE=512
OFFSET=$(($START_ADDRESS * $SECTOR_SIZE))

echo "Creating mountpoint: /mnt/tmpmnt "
mkdir /mnt/tmpmnt

echo "Mounting image: mount -o loop,offset=$OFFSET $TARGET_IMAGE_FILE /mnt/tmpmnt"
mount -o loop,offset=$OFFSET $TARGET_IMAGE_FILE /mnt/tmpmnt

echo "Exporting Kernel: cp /mnt/tmpmnt/kernel8.img $TARGET_KERNEL_FILE"
cp /mnt/tmpmnt/kernel*.img $TARGET_IMAGE_DIR

echo "Exporting dtb: cp /mnt/tmpmnt/*rpi*.dtb $TARGET_IMAGE_DIR"
cp /mnt/tmpmnt/*rpi*.dtb $TARGET_IMAGE_DIR

echo "generating password"
PASSWORD=$(echo 'raspberry' | openssl passwd -6 -stdin)

echo "saving userconf: pi:\$PASSWORD > /mnt/tmpmnt/userconf.txt"
echo "pi:$PASSWORD" > /mnt/tmpmnt/userconf.txt

echo "unmounting image: umount /mnt/tmpmnt"
umount /mnt/tmpmnt

echo "resizing image: qemu-img resize $TARGET_IMAGE_FILE 8G"
qemu-img resize $TARGET_IMAGE_FILE 8G