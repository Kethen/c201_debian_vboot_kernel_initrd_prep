FROM debian:bookworm
RUN sed -i 's/Components: main/Components: main non-free-firmware/g' /etc/apt/sources.list.d/debian.sources; cat /etc/apt/sources.list.d/debian.sources
RUN apt update; apt install -y firmware-linux-nonfree firmware-linux-free firmware-brcm80211
RUN apt update; apt install -y linux-image-armmp
RUN apt update; apt install -y u-boot-tools vboot-kernel-utils cgpt
RUN apt update; apt install -y e2fsprogs btrfs-progs f2fs-tools
