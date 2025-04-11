FROM debian:bookworm
RUN apt update; apt install -y linux-image-armmp u-boot-tools vboot-kernel-utils
