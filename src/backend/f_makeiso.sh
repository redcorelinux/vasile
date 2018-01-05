#!/usr/bin/env bash

jailisomnt () {
	mount -o bind packages "$jailsynctarget"/var/cache/packages
	mount -t proc proc "$jailsynctarget"/proc
	mount -t sysfs sysfs "$jailsynctarget"/sys
	mount -t devtmpfs -o relatime,size=3055348k,nr_inodes=763837,mode=755 none "$jailsynctarget"/dev
	mount -t devpts -o nosuid,noexec,relatime,gid=5,mode=620 none "$jailsynctarget"/dev/pts
	mount -t tmpfs -o nosuid,nodev none "$jailsynctarget"/dev/shm
	mount -t tmpfs -o nosuid,nodev,noexec none  "$jailsynctarget"/tmp
}

jailisodmnt () {
	umount -l "$jailsynctarget"/proc > /dev/null 2>&1
	umount -l "$jailsynctarget"/sys > /dev/null 2>&1
	umount -l "$jailsynctarget"/dev/pts > /dev/null 2>&1
	umount -l "$jailsynctarget"/dev/shm > /dev/null 2>&1
	umount -l "$jailsynctarget"/dev > /dev/null 2>&1
	umount -l "$jailsynctarget"/tmp > /dev/null 2>&1
	umount -l "$jailsynctarget"/var/cache/packages > /dev/null 2>&1
}

jailisobinmode () {
	chroot "$jailsynctarget" su - "$jailuser" -c "$jailbinmodecmd"
}

jailisomkramfs () {
	chroot "$jailsynctarget" su - "$jailuser" -c "$jaildracutcmd"
}

jailisomkefi () {
	chroot "$jailsynctarget" su - "$jailuser" -c "$jailmkx64eficmd"
	chroot "$jailsynctarget" su - "$jailuser" -c "$jailmkia32eficmd"
}

jailisomkchload () {
	chroot "$jailsynctarget" su - "$jailuser" -c "$jailmkchainloadercmd"
}

jailisoenserv () {
	chroot "$jailsynctarget" su - "$jailuser" -c "rc-update add redcorelive boot"
	for service in acpid dbus NetworkManager ModemManager avahi-daemon syslog-ng cupsd cronie cgmanager consolekit alsasound bluetooth ntpd openrc-settingsd xdm virtualbox-guest-additions ufw ; do
		chroot "$jailsynctarget" su - "$jailuser" -c "rc-update add "$service" default"
	done
}

jailisomkdkms () {
	chroot "$jailsynctarget" su - "$jailuser" -c "$jaildkmscmd"
}

jailisostart () {
	einfo "Oh no, I'm in jail!"
	chroot "$jailsynctarget" su - "$jailuser"
}

mkliveimg () {
	# create live filesystem image layout
	mkdir -p "$jailsynctarget"
	dd if=/dev/zero of=""$jailsynctarget".img" bs=1M count=15360
	sync
	mkfs.ext2 -F ""$jailsynctarget".img"
	mkdir -p "$jailsyncsource"
	mkdir -p "$jaildvdpath"
	mkdir -p "$jailsquashfspath"
	mkdir -p "$jailrealfspath"
	mkdir -p "$jailbootldrpath"
	mkdir -p "$jailefildrpath"
	sync
	# mount "stage4" image and sync live filesystem image core components
	mount -t squashfs "$jailx64" "$jailsyncsource"
	mount -t ext4 ""$jailsynctarget".img" "$jailsynctarget"
	rsync -aHAXr --progress "$jailsyncsource/" "$jailsynctarget/"
	sync
	# umount "stage4" image
	umount "$jailsyncsource"
	# copy live kernel image
	cp -avx ""$jailsynctarget"/boot/"$jailkernname"" ""$jailrootpath"/boot/vmlinuz"
	# create and copy live initramfs
	jailisomnt
	jailisomkramfs
	jailisodmnt
	mv ""$jailsynctarget"/boot/"$jailramfsname"" ""$jailrootpath"/boot/initrd"
	sync
	# create and copy EFI loader
	jailisomnt
	jailisomkefi
	jailisodmnt
	mv ""$jailsynctarget"/root/bootx64.efi" "$jailefildrpath"
	mv ""$jailsynctarget"/root/bootia32.efi" "$jailefildrpath"
	chmod 755 ""$jailefildrpath"/bootx64.efi"
	chmod 755 ""$jailefildrpath"/bootia32.efi"
	sync
	# create and copy syslinux -> grub chainloader for Unetbootin compatibility
	jailisomnt
	jailisomkchload
	jailisodmnt
	mv ""$jailsynctarget"/root/core.img" "$jailbootldrpath"
	cp -avx ""$jailsynctarget"/usr/lib64/grub/i386-pc/lnxboot.img" "$jailbootldrpath"
	sync
	# chroot into live filesystem image
	jailisomnt
	jailisobinmode
	jailisostart
	jailisodmnt
	sync
	# compile and install DKMS modules, if any
	jailisomnt
	jailisomkdkms
	jailisodmnt
	sync
	# enable live services
	jailisomnt
	jailisoenserv
	jailisodmnt
	sync
	# unmount live filesystem image
	umount -l "$jailsynctarget" > /dev/null 2>&1
	# move live filesystem image where it should be
	mv ""$jailsynctarget".img"  "$jailrealfspath"
	sync
	# compress live filesystem image
	mksquashfs "$jaildvdpath" ""$jailrootpath"/squashfs.img" -b 1048576 -comp xz -Xdict-size 100%
	sync
	# move compressed live filesystem image where it should be
	mv ""$jailrootpath/"squashfs.img" "$jailsquashfspath"
	sync
}

cfgbootldr () {
	# fetch and install GRUB2 config files
	git clone https://gitlab.com/"$distname"/boot-core.git "$jailbootldrdlpath"
	cp -avx "$jailbootldrcfgpath" "$jailrootpath"
	sync
}

mkclean () {
	# clean temporary resources
	rm -rf "$jailsyncsource"
	rm -rf "$jailsynctarget"
	rm -rf "$jaildvdpath"
	rm -rf "$jailbootldrdlpath"
}

mkisoimg () {
	# create the actual iso image
	grub2-mkrescue -o ""$jailrootpath".iso" "$jailrootpath"
}

makeiso () {
	checkifroot
	checkjailsum
	mkliveimg
	cfgbootldr
	mkclean
	mkisoimg
}
