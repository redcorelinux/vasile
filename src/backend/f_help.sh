#!/usr/bin/env bash

export local colorstart="\e[1;49;34m"
export local colorstop="\e[0m"

showhelp () {

echo -e "\
"$colorstart"SYNOPSIS"$colorstop"
	"$colorstart"vasile --option"$colorstop" ["$colorstart"arguments"$colorstop"]
	"$colorstart"vasile --help"$colorstop"

"$colorstart"DESCRIPTION"$colorstop"

	Vasile is an acronym for ** Versatile Advanced Script for Iso and Latest Enchantments **

"$colorstart"OPTIONS"$colorstop"
	"$colorstart"--makepkg"$colorstop" ["$colorstart"package(s)"$colorstop"]
		This option will allow you to build a package or multiple packages in an overlayfs mounted squashfs chroot jail.

		It must be run in the folder where the squashfs chroot jail resides, or else it will fail to mount the squahfs chroot jail and build the package(s).

		The squashfs chroot jail and the md5sum checksum file are hardcored into "$colorstart"libvasile"$colorstop", but you may want to change them to suit your needs.

		You MUST provide package(s) to build as arguments, or else vasile will only mount the chroot jail

		Examples :
			"$colorstart"vasile --makepkg wine"$colorstop"
			"$colorstart"vasile --makepkg wine playonlinux q4wine"$colorstop"

		If the package(s) is/are already built, it will not build it/them again (unless newer version(s) is/are available), but install it/them into squahfs chroot jail

		If the package(s) you want to build depends on any already built package(s) it will make use of it/them to satisfy the required dependencies.

	"$colorstart"--makeiso"$colorstop"
		This option will allow you to build a live iso image based on the squashfs chroot jail.

		It must be run in the folder where the squashfs chroot jail resides, or else it will fail to rsync the contents of it and build the iso image.

		It is not fully automatic, it will only rsync the contents of the squashfs chroot jail, chroot into it, and let you install packages you want into the iso image.
		There are some predefined package sets available in "$colorstart"/etc/portage/sets"$colorstop". Adjust them to suit your needs.

		It will ALLWAYS use package(s) built with "$colorstart"--makepkg"$colorstop" option. When you are happy with package selection, just exit the chroot environment and
		the live filesystem will be compressed, live services will be autoenabled, live bootloader autoconfigured and in the end live iso image will be built. You will find
		a list of predefined live services list hardcoded into "$colorstart"libvasile"$colorstop". Adjust it to suit your needs.

	"$colorstart"--adapt"$colorstop"
		This option will allow you to adjust the MAKEOPTS variable of portage. The default value is -j64 (compile using 64 CPU cores), but this is overkill for lower spec machines.
		You must call this option on a fresh install (to override the above overkill defaults) or when you add, remove, enable or disable CPU's (to adapt to more or less CPU cores). 
		Otherwise, it is called automatically at setup stage.

	"$colorstart"--reset"$colorstop"
		This option will allow you to reset portage. It will remove the portage tree snapshot, the Redcore Linux ebuild overlay, the portage configuration files and reset the system profile.
		Usually you will never want to call this option directly, unless you really really really know what are you doing. It is called automatically at setup stage.

		"$colorstart"!!! WARNING !!!"$colorstop"
		Never never never leave the system in this state. 
		You will no longer be able to install/remove/upgrade any packages untill you set the system profile, get the portage tree, overlays and configure portage.

	"$colorstart"--setup"$colorstop"
		This option will allow you to setup portage. It will fetch the portage tree snapshot, the Redcore Linux ebuild overlay, the portage configuration files and setup the system profile."

exit 0
}
