#!/usr/bin/env bash

checkifroot () {
	if [[ "$(whoami)" != root ]] ; then
		eerror "I won't do that, unless you're root!"
		exit 1
	fi
}

checkkerncfg () {
	if [[ $(zgrep 'CONFIG_OVERLAY_FS=' /proc/config.gz) && $(zgrep "CONFIG_SQUASHFS=" /proc/config.gz) &&  $(zgrep "CONFIG_BLK_DEV_LOOP=" /proc/config.gz) ]] ; then
		einfo "Kernel config OK, moving on"
	else
		eerror "I won't do that with the current kernel"
		eerror "I want a kernel with OVERLAYFS && SQUASHFS && LOOP DEVICES enabled"
		exit 1
	fi
}

checkiflive () {
	if [[ -L /dev/mapper/live-base ]] ; then
		eerror "I won't do that on a live system"
		exit 1
	fi
}

checkjailsum () {
	if [[ -f "$jailx64" && -f "$jailx64sum" ]] ; then
		if [[ "$(md5sum -c "$jailx64sum")" ]] ; then
			einfo "Jail integrity OK, moving on"
		else
			eerror "I won't do that with a corrupted jail"
			exit 1
		fi
	else
		eerror "I won't do that with a missing jail"
		exit 1
	fi
}

jaildkmsbuild () {
	checkifroot
	if [[ -x /usr/sbin/dkms ]] ; then
		for i in $(dkms status | cut -d " " -f1,2 | sed -e 's/,//g' | sed -e 's/ /\//g' | sed -e 's/://g') ; do
			dkms install $i
		done
	fi
}
