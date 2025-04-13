FROM debian:bookworm
RUN sed -i 's/Components: main/Components: main non-free-firmware/g' /etc/apt/sources.list.d/debian.sources; cat /etc/apt/sources.list.d/debian.sources
RUN echo 'deb http://deb.debian.org/debian bookworm-backports main non-free-firmware' > /etc/apt/sources.list.d/backports.list
RUN apt update; apt install -y firmware-linux-nonfree/bookworm-backports firmware-linux-free firmware-brcm80211/bookworm-backports
RUN apt update; apt install -y linux-image-armmp/bookworm-backports
RUN apt update; apt install -y u-boot-tools vboot-kernel-utils cgpt
RUN apt update; apt install -y e2fsprogs btrfs-progs f2fs-tools
