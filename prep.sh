set -xe

cp mkc201vboot /usr/bin
chmod 755 /usr/bin/mkc201vboot

mkc201vboot

rm -rf modules
mkdir modules

cp -r $(ls -d /usr/lib/modules/* | sort -r | head -n 1) ./modules/

if [ "$ROOTFSTAR" == "true" ]
then
	useradd -m user
	passwd user << EOF
user
user
EOF
	
	usermod -a -G sudo user
	usermod -s /usr/bin/bash user
	passwd -l root

	echo "$ROOT / $ROOTFS $ROOTFSOPT 0 1" > /etc/fstab

	#cp -r firmware/* /usr/lib/firmware/ || true
	cp firmware/brcm/brcmfmac4354-sdio.txt /usr/lib/firmware/brcm

	# https://wiki.gentoo.org/wiki/ASUS_Chromebook_C201#Built-in_wifi
	#echo "blacklist btsdio" > /etc/modprobe.d/blacklist-btsdio.conf

	export DEBIAN_FRONTEND=noninteractive
	apt update
	apt install -y man-db
	apt install -y bash-completion nano less
	apt install -y lm-sensors
	apt install -y firefox-esr chromium
	apt install -y iputils-ping bind9-dnsutils traceroute mtr iperf3 iperf ncat
	apt install -y cpio tar zstd gzip pbzip2 p7zip-full bzip2
	if [ "$USE_KDE" == "true" ]
	then
		apt install -y task-kde-desktop
		# oof konsole crashes, not sure when will debian fetch a newer version
		apt install -y lxterminal
	else
		apt install -y task-gnome-desktop
	fi

	cp systemd_units/simple_zswap.service /usr/lib/systemd/system/simple_zswap.service
	sudo ln -s /usr/lib/systemd/system/simple_zswap.service /usr/lib/systemd/system/multi-user.target.wants/simple_zswap.service

	# polkit bug..?
	chmod 555 /usr/share/polkit-1/rules.d

	tar -C / --exclude='./work_dir/*' --exclude='./dev/*' --exclude='./sys/*' --exclude='./proc/*' -cO . -f /work_dir/rootfs.tar
fi
