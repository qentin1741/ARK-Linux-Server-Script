#!/bin/bash

# Check for config file.
if [ -f configuration.ini ]; then
    # Config file.
    source configuration.ini
    if [ $safetyNotif = True ]; then
        clear
        echo
        sleep 1s
        echo " Found configuration file, checking it now."
    fi
else
    echo
    echo -e '\e[1;31m ERROR \e[0m'
    echo "No configuration file found. Dowloading from github now."
    echo
fi

# Config file.
source configuration.ini

if [ $safetySwitch = False ]; then
    echo =========================================================================
    echo
    echo -e '\e[1;31m ERROR \e[0m'
    echo " You have yet to edit the config file!"
    echo " Please edit the config and alter the 'Safety Switch' to TRUE once done."
    echo
    echo =========================================================================
    exit
else
    if [ $safetyNotif = True ]; then
        echo
        echo =========================================================
        echo
        echo " Safty Switch turned off. This script assumes you have"
        echo " configured the file correctly and are ready to move on."
        echo
        echo =========================================================
    fi
fi

help () {
    if [ $safetyNotif = True ]; then
        echo
        echo -e '\e[1;37m Use the following commands: \e[0m'
        echo
        echo " startserver.sh <start|stop|restart>"
        echo
    else
        clear
        echo
        echo -e '\e[1;37m Use the following commands: \e[0m'
        echo
        echo " startserver.sh <start|stop|restart>"
        echo
    fi
}

[ "$1" = "" ] && {
    help
    exit
}

$*
    echo
    echo COMPLETE.
    echo
exit 0
