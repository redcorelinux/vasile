#!/usr/bin/env bash

delmainporttree () {
	einfo "I am removing Gentoo ebuild tree"
	if [ -d ""$jailmainportpath"/.git" ] ; then
		find "$jailmainportpath" -mindepth 1 -exec rm -rf {} \; > /dev/null 2>&1
	fi
}

deladdonporttree () {
	einfo "I am removing Redcore ebuild tree"
	if [ -d ""$jailaddonportpath"/.git" ] ; then
		find "$jailaddonportpath" -mindepth 1 -exec rm -rf {} \; > /dev/null 2>&1
	fi
}

delportcfgtree () {
	einfo "I am removing portage configuration"
	rm ""$jailportcfgtarget"/make.conf" > /dev/null 2>&1
	rm ""$jailportcfgtarget"/make.profile" > /dev/null 2>&1
	rm "$jailportcfgtarget" > /dev/null 2>&1
	rm -rf "$jailportvcspath" > /dev/null 2>&1
}

resetmode () {
	checkifroot
	delmainporttree
	deladdonporttree
	delportcfgtree
}

getmainportsrctree () {
	if [ ! -d ""$jailmainportpath"/.git" ] ; then
		einfo "I am injecting Gentoo ebuild tree"
		cd "$jailmainportpath" && git init > /dev/null 2>&1
		git remote add origin https://pagure.io/redcore/portage.git
		git pull --depth=1 origin master
		git branch -u origin/master master
		rm -rf ""$jailmainportpath"/profiles/updates"
	fi
}

getmainportbintree () {
	if [ ! -d ""$jailmainportpath"/.git" ] ; then
		einfo "I am injecting Gentoo ebuild tree"
		cd "$jailmainportpath" && git init > /dev/null 2>&1
		git remote add origin https://pagure.io/redcore/portage.git
		git config core.sparsecheckout true
		echo "profiles/*" >> .git/info/sparse-checkout
		echo "metadata/*" >> .git/info/sparse-checkout
		echo "eclass/*" >> .git/info/sparse-checkout
		git pull --depth=1 origin master
		git branch -u origin/master master
		rm -rf ""$gentooportdir"/profiles/updates"
	fi
}

getaddonportsrctree () {
	if [ ! -d ""$jailaddonportpath"/.git" ] ; then
		einfo "I am injecting Redcore ebuild tree"
		cd "$jailaddonportpath" && git init > /dev/null 2>&1
		git remote add origin https://pagure.io/redcore/redcore-desktop.git
		git pull --depth=1 origin master
		git branch -u origin/master master
	fi
}

getaddonportbintree () {
	if [ ! -d ""$jailaddonportpath"/.git" ] ; then
		einfo "I am injecting Redcore ebuild tree"
		cd "$jailaddonportpath" && git init > /dev/null 2>&1
		git remote add origin https://pagure.io/redcore/redcore-desktop.git
		git config core.sparsecheckout true
		echo "profiles/*" >> .git/info/sparse-checkout
		echo "metadata/*" >> .git/info/sparse-checkout
		echo "eclass/*" >> .git/info/sparse-checkout
		git pull --depth=1 origin master
		git branch -u origin/master master
	fi
}

getportcfgtree () {
	pushd /opt > /dev/null 2>&1
	einfo "I am injecting portage configuration"
	git clone https://pagure.io/redcore/redcore-build.git
	popd > /dev/null 2>&1
}

getsrctree () {
	getmainportsrctree
	getaddonportsrctree
	getportcfgtree
}

getbintree () {
	getmainportbintree
	getaddonportbintree
	getportcfgtree
}

setmakeconf () {
	ln -sf "$jailportcfgsource" "$jailportcfgtarget"
	ln -sf "$jailportcfgtarget"/make.conf.amd64-generic "$jailportcfgtarget"/make.conf
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

setbinmode () {
	resetmode
	getbintree
	setmakeconf
	setmakeopts
	setprofile
}

setsrcmode () {
	resetmode
	getsrctree
	setmakeconf
	setmakeopts
	setprofiles
}
