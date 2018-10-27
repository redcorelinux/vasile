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

	"$colorstart"--binmode"$colorstop"
		This option will allow you to change the system state to binmode. In this state portage will allways use only binary packages from the binhost. It will fetch a minimal
		portage tree without any ebuilds in it, but only with portage profiles, metadata and eclass. It will also fetch overlay and portage configuration files, and will adjust
		"$colorstart"make.conf"$colorstop" for binary only usage. This system state is for those who just meet with the power of Gentoo.

		!!! WARNING !!! : Never never never modify or create any file in "$colorstart"/etc/portage/"$colorstop" in this state.

	"$colorstart"--srcmode"$colorstop"
		This option will allow you to change the system state to srcmode. In more clear terms, it will transform your Kogaion/Argent/Redcore system into pure Gentoo. Binary packages
		from the binhost will be ignored, and you will only install packages building from portage tree using emerge. It will fetch the full portage tree, the overlay and portage
		configuration files and adjust "$colorstart"make.conf"$colorstop" for ebuild only usage.

		In this system state you can modify whatever you want in "$colorstart"/etc/portage/"$colorstop". You can adjust useflags, keywords, masks, build environment and rebuild the whole system to suit you.
		You have the full power of Gentoo available only one command away!

		!!! WARNING !!! : Only use this system state if you have a strong knowledge of Gentoo tools e.g.: "$colorstart"emerge, equery, layman, eix, qlist, useflags, keywords, masks"$colorstop".	"
exit 0
}
