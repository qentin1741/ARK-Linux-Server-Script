#!/bin/bash

# Check for config file.
if [ -f configuration.ini ]; then
    # Config file.
    source configuration.ini
    if [ $safetyNotif = True ]; then
        clear
        echo
        sleep 1s
        echo " Configuration file found."
        echo
    fi
else
    clear
    echo
    echo -e ' \e[1;31mERROR\e[0m'
    echo " No configuration file found. Dowloading from github now."
    echo
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/configuration.ini -o configuration.ini -#
    if [ -f configuration.ini ]; then
        echo
        echo " Configuration file download was successful."
        echo " Please edit the config file before running the script again."
        echo
        echo " Command: ./arkserver.sh <start|stop|view>"
        echo
        exit 0
    else
        echo
        echo " The script was unable to obtain the configuration.ini file. Is Github down?"
        echo " Please try to download it yourself and add it to the same dir as this script."
        echo
        exit 0
    fi
fi

# Version Checker
version = 1.0.5

echo "Checking version with github."

cd .serverscript
curl curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/version.ini -o version.ini -# -o version.ini -#
source version.ini
cd ../

if [ $version = $arkserver ]; then
    echo
    echo "Your on the latest version! Moving forward."
    echo
else
    echo "Script update avaibale!"
    echo "Updating script. Please wait."
    echo
    echo "Downloading shell file."
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/arkserver.sh -o arkserver.sh -#
    echo "File overwritten. Please restart the script!"
    exit 0
fi

# Hard dep's check. If one isnt installed, it will install it whithout asking. Can change this in the future.
if [ -x /usr/bin/curl ]; then
    if [ $safetyNotif = True ]; then
        echo -e " \e[1;32mCURL Installed\e[0m"
    fi
else
    echo -e " \e[1;31mERROR\e[0m"
    echo " Script detects that curl is not installed. Installing it now."
    sudo apt-get install curl
    echo " CURL now installed."
fi

if [ -x /usr/bin/screen ]; then
    if [ $safetyNotif = True ]; then
        echo -e " \e[1;32mSCREEN Installed\e[0m"
    fi
else
    echo -e " \e[1;31mERROR\e[0m"
    echo " Script detects that Screen is not installed. Installing it now."
    sudo apt-get install screen
    echo " SCREEN now installed."
fi

if [ -x /usr/bin/git ]; then
    if [ $safetyNotif = True ]; then
        echo -e " \e[1;32mGIT Installed\e[0m"
    fi
else
    echo -e " \e[1;31mERROR\e[0m"
    echo " Script detects that Git is not installed. Installing it now."
    apt-get install git
    echo " GIT now installed."
fi

# Check if serverscript directory is already made.
if [ -d .serverscript ]; then
    if [ $safetyNotif = True ]; then
        clear
        echo
        sleep 1s
        echo " Script directory is found."
    fi
else
    echo
    echo -e ' \e[1;31mERROR\e[0m'
    echo " Unable to find script directory. Grabbing from github now..."
    mkdir .serverscript
    
    if [ -d .serverscript ]; then
        echo
        echo " Script directory created."
    else
        echo
        echo -e ' \e[1;31mERROR\e[0m'
        echo " Unable to make script directory. Try again as root user."
        exit 0
    fi
    
    cd .serverscript
    echo
    echo " Now downloading script files."
    echo
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/startserver -o startserver -#
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/stopserver -o stopserver -#
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/viewserver -o viewserver -#
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/installserver -o installserver -#
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/updateserver -o updateserver -#
    chmod 777 *
    
    if [ -e startserver -a -e stopserver -a -e viewserver ]; then
        echo
        echo " All scripts found."
        cd ../
    else
        echo " Unable able to find one or more of the scripts. Re-Downlading Them"
        echo
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/startserver -o startserver -#
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/stopserver -o stopserver -#
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/viewserver -o viewserver -#
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/installserver -o installserver -#
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/updateserver -o updateserver -#
        chmod 777 *
        
        if [ -e startserver -a -e stopserver -a -e viewserver ]; then
            echo
            echo " All scripts found."
            cd ../
        else
            echo
            echo " Second time failing the download. Now exiting. Try again later."
            echo
            exit 0
        fi
    fi
fi

# Config file.
dir

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
        echo " arkserver.sh <start|stop|view|install|update>"
        echo
    else
        clear
        echo
        echo -e '\e[1;37m Use the following commands: \e[0m'
        echo
        echo " arkserver.sh <start|stop|view|install|update>"
        echo
    fi
}

start () {
    clear
    cd .serverscript
    ./startserver
}

stop () {
    clear
    cd .serverscript
    ./stopserver
}

view () {
    clear
    cd .serverscript
    ./viewserver
}

install () {
    clear
    cd .serverscript
    ./installserver
}

update () {
    clear
    cd .serverscript
    ./updateserver
}

[ "$1" = "" ] && {
    help
    exit
}

$*
    echo
exit 0
