#!/usr/bin/env bash

if [[ -f /lib/gentoo/functions.sh ]] ; then
	source /lib/gentoo/functions.sh
else
	echo "I won't do that without sys-apps/gentoo-functions"
	exit 1
fi

if [[ -f /usr/lib/vasile/jailvars.sh ]] ; then
	source /usr/lib/vasile/jailvars.sh
else
	source jailvars.sh
fi

if [[ -f /usr/lib/vasile/jailcmds.sh ]] ; then
	source /usr/lib/vasile/jailcmds.sh
else
	source jailvars.sh
fi

if [[ -f /usr/lib/vasile/jailfuncs.sh ]] ; then
	source /usr/lib/vasile/jailfuncs.sh
else
	source jailfuncs.sh
fi
