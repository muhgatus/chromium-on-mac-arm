#!/bin/bash
#
# Install|Update Chromium Web browser on Mac OS
#
# Nicolargo
# GPL v3
#
SCRIPT_VERSION="1.32"

CHROMIUM_URL="http://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html?path=Mac_Arm"
CHROMIUM_URL2="http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac_Arm"
CHROMIUM_INSTALL_PATH="/Applications/"
CHROMIUM_CURRENT_VERSION_FILE="$CHROMIUM_INSTALL_PATH/Chromium.app/Contents/Info.plist"
#CHROMIUM_CURRENT_VERSION=`defaults read /Applications/Chromium.app/Contents/Info SVNRevision`
CHROMIUM_CURRENT_VERSION=`defaults read /Applications/Chromium.app/Contents/Info SCMRevision`

if [[ ! $CHROMIUM_CURRENT_VERSION =~ ^-?[0-9]+$ ]]
then
	CHROMIUM_CURRENT_VERSION=${CHROMIUM_CURRENT_VERSION#*master\@\{#}
	CHROMIUM_CURRENT_VERSION=${CHROMIUM_CURRENT_VERSION%\}}
fi

echo "Chromium version installed: $CHROMIUM_CURRENT_VERSION"
echo "Checking for update: $CHROMIUM_URL2/LAST_CHANGE"
CHROMIUM_LATEST_VERSION=$(curl -s -S $CHROMIUM_URL2/LAST_CHANGE)
echo "Latest Chromium version   :  $CHROMIUM_LATEST_VERSION"

if [ "$CHROMIUM_CURRENT_VERSION" == "" ] || [ $CHROMIUM_CURRENT_VERSION -lt $CHROMIUM_LATEST_VERSION ]; then
	echo "Latest version of Chromium will be installed"
	echo "Checking if Chromium is running"
	if [ `ps -A | grep Chromium | wc -l` != 1 ]; then
		echo "ERROR : Chromium must be closed before install new version"
		exit 1
	fi

	echo "Downloading Chromium version $CHROMIUM_LATEST_VERSION"
	echo "URL = $CHROMIUM_URL2/$CHROMIUM_LATEST_VERSION/chrome-mac.zip"
	curl -L $CHROMIUM_URL2/$CHROMIUM_LATEST_VERSION/chrome-mac.zip > /tmp/chrome-mac.zip
	cd /tmp
	unzip chrome-mac.zip
	rm -rf $CHROMIUM_INSTALL_PATH/Chromium.app.old
	mv $CHROMIUM_INSTALL_PATH/Chromium.app $CHROMIUM_INSTALL_PATH/Chromium.app.old
	cp -R chrome-mac/Chromium.app $CHROMIUM_INSTALL_PATH
	rm -Rf /tmp/chrome-mac*
	echo "Chromium version $CHROMIUM_LATEST_VERSION installed"
        cd $CHROMIUM_INSTALL_PATH
        xattr -rc Chromium.app
else
	echo "No update available, you already have the latest version"
fi
