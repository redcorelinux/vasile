#!/usr/bin/env bash
# Say Hello to Vasile, a modular script to build Redcore Linux packages && ISO images using a clean squashfs + overlayfs chroot
# Main author : Ghiunhan Mamut (aka V3n3RiX)
# Dependencies : kernel built with squashfs + overlayfs + loopback support && sys-fs/grub:2 && sys-fs/squashfs-tools && dev-libs/libisoburn && sys-fs/mtools
#

# Import our variables and functions

source /usr/lib/vasile/f_import.sh

# Vasile need root privileges and a proper kernel to run
# Also, running it in live mode is a really bad idea

checkiflive
checkkerncfg

case $1 in
	--makepkg)
		makepkg
		;;
	--makeiso)
		makeiso
		;;
	--binmode)
		setbinmode
		;;
	--srcmode)
		setsrcmode
		;;
	--dkms)
		makedkms
		;;
	--help)
		showhelp
		;;
	*)
		eerror "error: no operation specified, use --help for help"
		;;
esac

exit 0
