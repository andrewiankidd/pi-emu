FROM ubuntu

RUN  apt-get update \
  && apt-get install -y curl fdisk wget unzip xz-utils qemu-utils

WORKDIR /home
ENTRYPOINT [ "/home/builder/build.sh" ]