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
	einfo "I am removing ebuild tree configuration"
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
		git remote add origin https://gitlab.com/redcore/portage.git
		git pull --depth=1 origin master
		git branch -u origin/master master
		rm -rf ""$jailmainportpath"/profiles/updates"
	fi
}

dlmainportmintree () {
	if [ ! -d ""$jailmainportpath"/.git" ] ; then
		einfo "I am injecting Gentoo ebuild tree"
		cd "$jailmainportpath" && git init > /dev/null 2>&1
		git remote add origin https://gitlab.com/redcore/portage.git
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
		git remote add origin https://gitlab.com/redcore/redcore-desktop.git
		git pull --depth=1 origin master
		git branch -u origin/master master
	fi
}

dladdonportmintree () {
	if [ ! -d ""$jailaddonportpath"/.git" ] ; then
		einfo "I am injecting Redcore ebuild tree"
		cd "$jailaddonportpath" && git init > /dev/null 2>&1
		git remote add origin https://gitlab.com/redcore/redcore-desktop.git
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
	einfo "I am injecting ebuild tree configuration"
	git clone https://gitlab.com/redcore/redcore-build.git
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

setbinmodecfg () {
	ln -sf "$jailportcfgsource" "$jailportcfgtarget"
	ln -sf "$jailportcfgtarget"/make.conf.amd64-binmode "$jailportcfgtarget"/make.conf
	eselect profile set redcore:default/linux/amd64/13.0
	env-update
	. /etc/profile
}

binmode () {
	resetmode
	injectportmintree
	setbinmodecfg
}

setmixedmodecfg () {
	ln -sf "$jailportcfgsource" "$jailportcfgtarget"
	ln -sf "$jailportcfgtarget"/make.conf.amd64-mixedmode "$jailportcfgtarget"/make.conf
	eselect profile set redcore:default/linux/amd64/13.0
	env-update
	. /etc/profile
}

mixedmode () {
	resetmode
	injectportfulltree
	setmixedmodecfg
}

setsrcmodecfg () {
	ln -sf "$jailportcfgsource" "$jailportcfgtarget"
	ln -sf "$jailportcfgtarget"/make.conf.amd64-srcmode "$jailportcfgtarget"/make.conf
	eselect profile set redcore:default/linux/amd64/13.0
	env-update
	. /etc/profile
}

srcmode() {
	resetmode
	injectportfulltree
	setsrcmodecfg
}
