Based on https://wiki.debian.org/InstallingDebianOn/Asus/C201 and https://wiki.gentoo.org/wiki/ASUS_Chromebook_C201, for enabling developer mode and setting up initial partition table, see the instructions there

### Prerequisites

- linux
- `podman`
- armhf compatible cpu, or `qemu-arm` arm linux user space emulator, configured to work with `podman`

### Usage

#### Producing just the vboot image

```
# check your root partition uuid with `blkid`, then prepare the vboot image
ROOT="UUID=<uuid>" bash prep_podman.sh

# install the vboot image
sudo dd if=vmlinuz_initrd.signed of=<kernel partition> bs=8M oflag=dsync

# install kernel modules
mkdir mnt
sudo mount <rootfs partition> mnt
sudo cp -r modules/* mnt/usr/lib/modules/
sudo umount mnt
```

#### Produce rootfs and vboot

```
# format rootfs partition, ext4 for example
sudo mkfs.ext4 <rootfs partition>

# check your root partition uuid with `blkid`
# adjust ROOTFS and ROOTFSOPT according to your file system choice for the root filesystem
ROOT="UUID=<uuid>" ROOTFSTAR=true ROOTFS=ext4 ROOTFSOPT=defaults bash prep_podman.sh

# install the vboot image
sudo dd if=vmlinuz_initrd.signed of=<kernel partition> bs=8M oflag=dsync

# install rootfs
mkdir mnt
sudo mount <rootfs partition> mnt
sudo tar -C mnt -xf rootfs.tar
sudo umount mnt
```

#### First boot with the created debian rootfs

```
# default user-password is user-user
sudo passwd user
sudo passwd root
```

#### Troubleshooting

- The firmware seems to not like large vboot images, the overall limit seems to be roughly 32MB

### Example partition table creation steps

```
sudo gdisk /dev/sdd
GPT fdisk (gdisk) version 1.0.10

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.

Command (? for help): o
This option deletes all partitions and creates a new protective MBR.
Proceed? (Y/N): y

Command (? for help): n
Partition number (1-128, default 1): 
First sector (34-124735454, default = 2048) or {+-}size{KMGTP}: 
Last sector (2048-124735454, default = 124733439) or {+-}size{KMGTP}: +32M
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 7f00
Changed type of partition to 'ChromeOS kernel'

Command (? for help): n
Partition number (2-128, default 2): 
First sector (34-124735454, default = 67584) or {+-}size{KMGTP}: 
Last sector (67584-124735454, default = 124733439) or {+-}size{KMGTP}: 
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 
Changed type of partition to 'Linux filesystem'

Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): y
OK; writing new GUID partition table (GPT) to /dev/sdd.
The operation has completed successfully.

sudo cgpt add -i 1 -S 1 -T 5 -P 12 /dev/sdd
```
