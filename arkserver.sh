#!/bin/bash

# Colors 
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
RESET='\e[0m'
# Messages
ERR='\e[1;31m ERROR\e[0m'

# Version Checker
version="1.0.9"

echo -e; echo -e "$YELLOW Checking version with github. $RESET"
if [ -f version.ini ]; then
    rm version.ini
fi

curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/version.ini -o version.ini -# -o version.ini -#
source version.ini
if [ $version != $arkserver ]; then
    echo -e "$YELLOW Script update avaibale! $RESET"
    echo -e "$YELLOW Downloading shell file. $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/arkserver.sh -o arkserver.sh -#
    echo -e "$GREEN File overwritten. Please restart the script. $RESET"
    exit 0
else
    echo -e " Up to date!"; echo -e
fi

if [ -f configuration.ini ]; then
source configuration.ini
    if [ -z $configVersion ]; then
        echo -e "$ERR You have an outdated configuration file!"; echo -e
        echo -e "$YELLOW There is a config update! any config updaters are important to the script. $RESET"
        echo -e "$YELLOW The script will make a backup of your current config. However you will have to $RESET"
        echo -e "$YELLOW re edit the config file. Sorry for the flaw in this design of the script. $RESET"
        sleep 1s
        mv configuration.ini configuration_backup.ini
        echo -e; echo -e "$YELLOW File backed up. Downloading new config file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/configuration.ini -o configuration.ini -#
        echo -e; echo -e "$GREEN Configuration file updated. Please edit your config once again then restart the script. $RESET"
        echo -e "$GREEN Most options you can simply copy paste as most config updaters are additions/formatting. $RESET"
        echo -e; exit 0
    fi

    if [ $configVersion != $liveConfig ]; then
        echo -e "$YELLOW There is a config update! any config updaters are important to the script. $RESET"
        echo -e "$YELLOW The script will make a backup of your current config. However you will have to $RESET"
        echo -e "$YELLOW re edit the config file. Sorry for the flaw in this design of the script. $RESET"
        sleep 1s
        mv configuration.ini configuration_backup.ini
        echo -e "$YELLOW File backed up. Downloading new config file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/configuration.ini -o configuration.ini -#
        echo -e; echo -e "$GREEN Configuration file updated. Please edit your config once again then restart the script. $RESET"
        echo -e "$GREEN Most options you can simply copy paste as most config updaters are additions/formatting. $RESET"
        echo -e; exit 0
    fi
fi

# Check for config file.
if [ -f configuration.ini ]; then
    # Config file.
    source configuration.ini
    if [ $safetyNotif = True ]; then
        clear
        echo -e; sleep 1s
        echo -e "$YELLOW Configuration file found. $RESET"; echo -e
    fi
else
    clear
    echo -e; echo -e "$ERR No configuration file found. Dowloading from github now."
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/configuration.ini -o configuration.ini -#
    if [ -f configuration.ini ]; then
        echo -e; echo -e "$GREEN Configuration file download was successful."
        echo -e " Please edit the config file before running the script again."
        echo -e; echo -e " Command: ./arkserver.sh <start|stop|view>"
        echo -e; exit 0
    else
        echo -e "$ERR The script was unable to obtain the configuration.ini file. Is Github down?"
        echo -e " Please try to download it yourself and add it to the same dir as this script."
        echo -e; exit 0
    fi
fi

# Hard dep's check. If one isnt installed, it will install it whithout asking. Can change this in the future.
if [ -x /usr/bin/curl ]; then
    if [ $safetyNotif = True ]; then
        echo -e "$GREEN CURL Installed $RESET"
    fi
else
    echo -e"$ERR Script detects that curl is not installed. Installing it now."
    sudo apt-get install curl
    echo "$YELLOW CURL now installed $RESET"
fi

if [ -x /usr/bin/screen ]; then
    if [ $safetyNotif = True ]; then
        echo -e "$GREEN SCREEN Installed $RESET"
    fi
else
    echo -e "$ERR Script detects that Screen is not installed. Installing it now."
    sudo apt-get install screen
    echo "$YELLOW SCREEN now installed $RESET"
fi

if [ -x /usr/bin/git ]; then
    if [ $safetyNotif = True ]; then
        echo -e "$GREEN GIT Installed $RESET"
    fi
else
    echo -e "$ERR Script detects that Git is not installed. Installing it now."
    apt-get install git
    echo "$YELLOW GIT now installed. $RESET"
fi

if [ -z "$(iptables -nL | grep $querryPort)" ]; then
    echo -e " Adding iptables requirments. (Querry Port)"
    iptables -I INPUT -p udp --dport $querryPort -j ACCEPT
    iptables -I INPUT -p tcp --dport $querryPort -j ACCEPT
else
    echo -e " IPTables responded correctly. (Querry Port)"
fi

if [ -z "$(iptables -nL | grep $serverPort)" ]; then
    echo -e " Adding iptables requirments. (Server Port)"
    iptables -I INPUT -p udp --dport $serverPort -j ACCEPT
    iptables -I INPUT -p tcp --dport $serverPort -j ACCEPT
else
    echo -e " IPTables responded correctly. (Server Port)"
fi


# Check if serverscript directory is already made.
if [ -d .serverscript ]; then
    if [ $safetyNotif = True ]; then
        echo -e; sleep 1s
        echo -e " Script directory is found."
    fi
else
    echo -e "$ERR Unable to find script directory. Making it now."
    mkdir .serverscript
    cd .serverscript
    echo -e; echo -e "$YELLOW Now downloading script files. $RESET"; echo -e
    echo -e "$YELLOW Start Script $RESET" ; curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/startserver -o startserver -#
    echo -e "$YELLOW Stop Script $RESET" ; curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/stopserver -o stopserver -#
    echo -e "$YELLOW View Script $RESET" ; curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/viewserver -o viewserver -#
    echo -e "$YELLOW Install Script $RESET" ; curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/installserver -o installserver -#
    echo -e "$YELLOW Update Script $RESET" ; curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/updateserver -o updateserver -#
    echo -e "$YELLOW Backup Script $RESET" ; curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/backupserver -o backupserver -#
    echo -e "$YELLOW Formatting $RESET" ; curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/formatting.ini -o formatting.ini -#
    chmod 777 *
    cd ../
fi

# Config file.
source configuration.ini
#dir

if [ $safetySwitch = False ]; then
    echo -e =========================================================================
    echo -e
    echo -e "$ERR You have yet to edit the config file!"
    echo -e " Please edit the config and alter the 'Safety Switch' to TRUE once done."
    echo -e
    echo -e =========================================================================
    exit
else
    if [ $safetyNotif = True ]; then
        echo -e
        echo -e =========================================================
        echo -e
        echo -e "$ERR Safty Switch turned off. This script assumes you have"
        echo " configured the file correctly and are ready to move on."
        echo -e
        echo -e =========================================================
    fi
fi

help () {
    if [ $safetyNotif != True ]; then
        clear
    fi
    echo -e
    echo -e '$WHITE Use the following commands: $RESET'
    echo -e
    echo -e "$CYAN arkserver.sh <start|stop|view|install|update> $RESET"
    echo -e
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
