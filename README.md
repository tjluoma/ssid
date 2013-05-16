ssid
====

A shell script to check the current AirPort/Wi-Fi SSID and take actions depending on which SSID it finds.

## The `airport` command ##

The `airport` command can be found at 

	/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport

It has been there at least since 10.6 and the syntax (AFAIK) has not changed.

I do this as part of my initial setup of a new Mac:

	cd /usr/local/bin
	
	ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport .

That way I have the `airport` command in my $PATH and if Apple updates it, I will still be using the current version.

### The simple version ###

At its core, this script is really built around one line:

	airport -I | awk -F': ' '/ SSID/{print $NF}'

That will show you the current SSID that you are connected to. If you are not connected to any AirPort/Wi-Fi networks, it will not show anything.

### The slightly more complicated version ###

If you want to be able to determine whether or not the AirPort card is turned off, use this:

	airport -I | egrep 'AirPort: Off|^ *SSID: ' | sed 's#^ *SSID: ##g'

If you get an SSID of

	AirPort: Off

then you know that it is off.

If you need to turn the AirPort card on, you can do that with this:

	networksetup -setairportpower enX on

where "X" is probably either 0 or 1. You can probably find out by:

*Hacky-but-shorter* way:

		networksetup -setairportpower enX off 2>&1 |\
		awk -F' ' '/:/{print $NF}'

*Cleaner* way:

		networksetup -listnetworkserviceorder |\
		awk -F' ' '/(Wi-Fi|AirPort)/{print $NF}' |\
		awk -F')' '/^en/{print $1}'


