#!/usr/bin/env bash

jailpkgprep () {
	while : true ; do
		if [[ ! -d "$ropath" && ! -d "$rwpath" && ! -d "$workpath" && ! -d "$overlaypath" ]] ; then
			for i in "$ropath" "$rwpath" "$workpath" "$overlaypath" ; do
				mkdir "$i"
			done
			jailpkgmnt
			break
		elif [[ -d "$ropath" && -d "$rwdpath" && -d "$workpath" && -d "$overlaypath" ]] ; then
			jailpkgdmnt
			for i in "$ropath" "$rwpath" "$workpath" "$overlaypath" ; do
				rm -rf "$i"
			done
			continue
		fi
	done
}

jailpkgmnt () {
	mount -t squashfs "$jailx64" "$ropath"
	mount -t overlay -o lowerdir="$ropath",upperdir="$rwpath",workdir="$workpath" overlay "$overlaypath"
	mount -o bind packages "$overlaypath"/var/cache/packages
	mount -o bind distfiles "$overlaypath"/var/cache/distfiles
	mount -t proc proc "$overlaypath"/proc
	mount -t sysfs sysfs "$overlaypath"/sys
	mount -t devtmpfs -o relatime,size=3055348k,nr_inodes=763837,mode=755 none "$overlaypath"/dev
	mount -t devpts -o nosuid,noexec,relatime,gid=5,mode=620 none "$overlaypath"/dev/pts
	mount -t tmpfs -o nosuid,nodev none "$overlaypath"/dev/shm
}

jailpkgdmnt () {
	umount -l "$overlaypath"/proc > /dev/null 2>&1
	umount -l "$overlaypath"/sys > /dev/null 2>&1
	umount -l "$overlaypath"/dev/pts > /dev/null 2>&1
	umount -l "$overlaypath"/dev/shm > /dev/null 2>&1
	umount -l "$overlaypath"/dev > /dev/null 2>&1
	umount -l "$overlaypath"/var/cache/packages > /dev/null 2>&1
	umount -l "$overlaypath"/var/cache/distfiles > /dev/null 2>&1
	umount -l "$overlaypath" > /dev/null 2>&1
	umount -l "$ropath" > /dev/null 2>&1
}

jailpkgsrcmode () {
	chroot "$overlaypath" su - "$jailuser" -c "$jailsrcmodecmd"
}

jailpkgbuild () {
	chroot "$overlaypath" su - "$jailuser" -c "$jailportagecmd"
}

jailpkgstart () {
	einfo "Oh no, I'm in jail!"
	chroot "$overlaypath" su - "$jailuser"
}

makepkg () {
	checkifroot
	checkjailsum
	jailpkgprep
	jailpkgsrcmode
	jailpkgbuild
	jailpkgstart
	jailpkgdmnt
}
