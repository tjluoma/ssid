#!/bin/zsh -f
# PURPOSE: output SSID (if any) to stdout.
#
# Exit codes:
#	2 if airport is not found
#	1 if no SSID or AirPort is turned off.
#	0 if SSID is found.
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2013-03-14

NAME="$0:t"

	# This command has been present since at least 10.6
AIRPORT='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'

if [ ! -x "${AIRPORT}" ]
then

		# airport command not found where expected
		exit 2
fi

	# Check for the SSID
	# but also check for 'AirPort: Off' which indicates AirPort card is turned off at the OS level
SSID=$(${AIRPORT} -I | egrep 'AirPort: Off|^ *SSID: ' | sed 's#^ *SSID: ##g')

if [[ "$SSID" == "AirPort: Off" ]]
then

		# AirPort (Wi-Fi) is turned off
		exit 1

elif [[ "$SSID" == "" ]]
then
		# No SSID found

		exit 1
fi

echo "$SSID"

exit 0

#
#EOF
