Based on https://wiki.debian.org/InstallingDebianOn/Asus/C201 , for enabling developer mode, see the instructions there

### Prerequisites

podman

### Usage

```
bash prep_podman.sh
dd if=vmlinuz_initrd.signed of=<kernel partition> bs=8M oflag=dsync
```
