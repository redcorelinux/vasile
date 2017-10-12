#!/usr/bin/env bash

if [[ -f /lib/gentoo/functions.sh ]] ; then
	source /lib/gentoo/functions.sh
else
	echo "I won't do that without sys-apps/gentoo-functions"
	exit 1
fi

if [[ -f /usr/lib/vasile/variables_jail.sh ]] ; then
	source /usr/lib/vasile/variables_jail.sh
else
	source variables_jail.sh
fi

if [[ -f /usr/lib/vasile/commands_jail.sh ]] ; then
	source /usr/lib/vasile/commands_jail.sh
else
	source commands_jail.sh
fi

if [[ -f /usr/lib/vasile/gfunctions_generic.sh ]] ; then
	source /usr/lib/vasile/functions_generic.sh
else
	source functions_generic.sh
fi

if [[ -f /usr/lib/vasile/functions_makepkg.sh ]] ; then
	source /usr/lib/vasile/functions_makepkg.sh
else
	source functions_makepkg.sh
fi

if [[ -f /usr/lib/vasile/functions_makeiso.sh ]] ; then
	source /usr/lib/vasile/functions_makeiso.sh
else
	source functions_makeiso.sh
fi

if [[ -f /usr/lib/vasile/functions_modeswitch.sh ]] ; then
	source /usr/lib/vasile/functions_modeswitch.sh
else
	source functions_modeswitch.sh
fi
