#!/usr/bin/env bash

if [[ -f /lib/gentoo/functions.sh ]] ; then
	source /lib/gentoo/functions.sh
else
	echo "Cannot import Gentoo functions, I will abort now!"
	exit 1
fi

if [[ -f /usr/lib/vasile/v_jail.sh ]] ; then
	source /usr/lib/vasile/v_jail.sh
else
	echo "Cannot import jail variables, I will abort now!"
	exit 1
fi

if [[ -f /usr/lib/vasile/c_jail.sh ]] ; then
	source /usr/lib/vasile/c_jail.sh
else
	echo "Cannot import jail commands, I will abort now!"
	exit 1
fi

if [[ -f /usr/lib/vasile/f_generic.sh ]] ; then
	source /usr/lib/vasile/f_generic.sh
else
	echo "Cannot import generic functions, I will abort now!"
	exit 1
fi

if [[ -f /usr/lib/vasile/f_makepkg.sh ]] ; then
	source /usr/lib/vasile/f_makepkg.sh
else
	echo "Cannot import makepkg functions, I will abort now!"
	exit 1
fi

if [[ -f /usr/lib/vasile/f_makeiso.sh ]] ; then
	source /usr/lib/vasile/f_makeiso.sh
else
	echo "Cannot import makeiso functions, I will abort now!"
	exit 1
fi

if [[ -f /usr/lib/vasile/f_modeswitch.sh ]] ; then
	source /usr/lib/vasile/f_modeswitch.sh
else
	echo "Cannot import modeswitch functions, I will abort now!"
	exit 1
fi

if [[ -f /usr/lib/vasile/f_help.sh ]] ; then
	source /usr/lib/vasile/f_help.sh
else
	echo "Cannot import help functions, I will abort now!"
	exit 1
fi
