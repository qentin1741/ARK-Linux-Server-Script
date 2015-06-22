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
    clear
    echo
    echo -e '\e[1;31m ERROR \e[0m'
    echo " No configuration file found. Dowloading from github now."
    echo
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/configuration.ini -o configuration.ini -#
    if [ -f configuration.ini ]; then
        echo
        echo "Configuration file download was successful."
        echo "Please edit the config file before running the script again."
        echo
        exit 0
    else
        echo
        echo "The script was unable to obtain the configuration.ini file. Is Github down?"
        echo "Please try to download it yourself and add it to the same dir as this script."
        echo
        exit 0
    fi
fi

if [ -d .serverscript ]; then
    if [ $safetyNotif = True ]; then
        clear
        echo
        sleep 1s
        echo " Script directory is found."
    fi
else
    echo
    echo -e '\e[1;31m ERROR \e[0m'
    echo " Unable to find script directory. Grabbing from github now..."
    mkdir .serverscript
    if [ -d .serverscript ]; then
        echo
        echo "Script directory created."
    else
        echo
        echo -e '\e[1;31m ERROR \e[0m'
        echo " Unable to make script directory. Try again as root user."
        exit 0
    fi
    
    cd .serverscript
    echo
    echo "Now downloading script files."
    echo
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/startserver -o startserver -#
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/stopserver -o stopserver -#
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/viewserver -o viewserver -#
    chmod 777 *
    
    if [ -e startserver -a -e stopserver -a -e viewserver ]; then
        echo
        echo "All scripts found."
        echo
        cd ../
    else
        echo "Unable able to find one or more of the scripts. Re-Downlading Them"
        echo
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/startserver -o startserver -#
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/stopserver -o stopserver -#
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/viewserver -o viewserver -#
        chmod 777 *
        
        if [ -e startserver -a -e stopserver -a -e viewserver ]; then
            echo
            echo "All scripts found."
            echo
            cd ../
        else
            echo
            echo "Second time failing the download. Now exiting. Try again later."
            echo
            exit 0
        fi
    fi
fi

echo
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
        echo " arkserver.sh <start|stop|restart>"
        echo
    else
        clear
        echo
        echo -e '\e[1;37m Use the following commands: \e[0m'
        echo
        echo " arkserver.sh <start|stop|restart>"
        echo
    fi
}

start () {
    cd .serverscript
    ./startscript
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
