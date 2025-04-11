Based on https://wiki.debian.org/InstallingDebianOn/Asus/C201 , for enabling developer mode and setting up initial partition table, see the instructions there

### Prerequisites

podman

### Usage

```
# check your root partition uuid with `blkid`, then prepare the vboot image
ROOT="UUID=0e4c8fdd-c15f-4b23-b991-d2c0e34186a1" bash prep_podman.sh

# install the vboot image
sudo dd if=vmlinuz_initrd.signed of=<kernel partition> bs=8M oflag=dsync

# install kernel modules
mkdir mnt
sudo mount <rootfs partition> mnt
sudo cp -r *-armmp mnt/usr/lib/modules/
sudo umount mnt
```
