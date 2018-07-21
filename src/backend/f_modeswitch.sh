#!/usr/bin/env bash

rmmainporttree () {
	einfo "I am removing Gentoo ebuild tree"
	if [ -d ""$jailmainportpath"/.git" ] ; then
		find "$jailmainportpath" -mindepth 1 -exec rm -rf {} \; > /dev/null 2>&1
	fi
}

rmaddonporttree () {
	einfo "I am removing Redcore ebuild tree"
	if [ -d ""$jailaddonportpath"/.git" ] ; then
		find "$jailaddonportpath" -mindepth 1 -exec rm -rf {} \; > /dev/null 2>&1
	fi
}

rmportcfgtree () {
	einfo "I am removing portage configuration"
	rm ""$jailportcfgtarget"/make.conf" > /dev/null 2>&1
	rm ""$jailportcfgtarget"/make.profile" > /dev/null 2>&1
	rm "$jailportcfgtarget" > /dev/null 2>&1
	rm -rf "$jailportvcspath" > /dev/null 2>&1
}

resetmode () {
	checkifroot
	rmmainporttree
	rmaddonporttree
	rmportcfgtree
}

dlmainportfulltree () {
	if [ ! -d ""$jailmainportpath"/.git" ] ; then
		einfo "I am injecting Gentoo ebuild tree"
		cd "$jailmainportpath" && git init > /dev/null 2>&1
		git remote add origin http://redcorelinux.org/cgit/portage/
		git pull --depth=1 origin master
		git branch -u origin/master master
		rm -rf ""$jailmainportpath"/profiles/updates"
	fi
}

dlmainportmintree () {
	if [ ! -d ""$jailmainportpath"/.git" ] ; then
		einfo "I am injecting Gentoo ebuild tree"
		cd "$jailmainportpath" && git init > /dev/null 2>&1
		git remote add origin http://redcorelinux.org/cgit/portage/
		git config core.sparsecheckout true
		echo "profiles/*" >> .git/info/sparse-checkout
		echo "metadata/*" >> .git/info/sparse-checkout
		echo "eclass/*" >> .git/info/sparse-checkout
		git pull --depth=1 origin master
		git branch -u origin/master master
		rm -rf ""$gentooportdir"/profiles/updates"
	fi
}

dladdonportfulltree () {
	if [ ! -d ""$jailaddonportpath"/.git" ] ; then
		einfo "I am injecting Redcore ebuild tree"
		cd "$jailaddonportpath" && git init > /dev/null 2>&1
		git remote add origin http://redcorelinux.org/cgit/redcore-desktop/
		git pull --depth=1 origin master
		git branch -u origin/master master
	fi
}

dladdonportmintree () {
	if [ ! -d ""$jailaddonportpath"/.git" ] ; then
		einfo "I am injecting Redcore ebuild tree"
		cd "$jailaddonportpath" && git init > /dev/null 2>&1
		git remote add origin http://redcorelinux.org/cgit/redcore-desktop/
		git config core.sparsecheckout true
		echo "profiles/*" >> .git/info/sparse-checkout
		echo "metadata/*" >> .git/info/sparse-checkout
		echo "eclass/*" >> .git/info/sparse-checkout
		git pull --depth=1 origin master
		git branch -u origin/master master
	fi
}

dlportcfgtree () {
	pushd /opt > /dev/null 2>&1
	einfo "I am injecting portage configuration"
	git clone http://redcorelinux.org/cgit/redcore-build/
	popd > /dev/null 2>&1
}

injectportmintree () {
	dlmainportmintree
	dladdonportmintree
	dlportcfgtree
}

injectportfulltree () {
	dlmainportfulltree
	dladdonportfulltree
	dlportcfgtree
}

setmakeopts () {
	einfo "I am setting portage to use $(getconf _NPROCESSORS_ONLN) jobs to compile packages"
	# default MAKEOPTS value is -j64, but that's overkill for lower spec machines
	# this will adjust MAKEOPTS to a value detected by $(getconf _NPROCESSORS_ONLN)
	sed -i "s/\-j64/\-j$(getconf _NPROCESSORS_ONLN)/g" "$jailportcfgtarget"/global.conf/makeopts.conf # global makeopts (exclude kernel)
	sed -i "s/\-j64/\-j$(getconf _NPROCESSORS_ONLN)/g" "$jailportcfgtarget"/env/makenoise.conf # kernel makeopts
}

setprofile () {
	eselect profile set default/linux/amd64/17.0/hardened
	env-update
	. /etc/profile
}

setbinmodecfg () {
	ln -sf "$jailportcfgsource" "$jailportcfgtarget"
	ln -sf "$jailportcfgtarget"/make.conf.amd64-binmode "$jailportcfgtarget"/make.conf
}

binmode () {
	resetmode
	injectportmintree
	setbinmodecfg
	setprofile
}

setmixedmodecfg () {
	ln -sf "$jailportcfgsource" "$jailportcfgtarget"
	ln -sf "$jailportcfgtarget"/make.conf.amd64-mixedmode "$jailportcfgtarget"/make.conf
}

mixedmode () {
	resetmode
	injectportfulltree
	setmixedmodecfg
	setmakeopts
	setprofile
}

setsrcmodecfg () {
	ln -sf "$jailportcfgsource" "$jailportcfgtarget"
	ln -sf "$jailportcfgtarget"/make.conf.amd64-srcmode "$jailportcfgtarget"/make.conf
}

srcmode() {
	resetmode
	injectportfulltree
	setsrcmodecfg
	setmakeopts
	setprofile
}
