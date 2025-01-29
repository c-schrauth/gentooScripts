#!/bin/bash

VERSION='0.3'

BOLD=`tput bold`
RESET=`tput sgr0`
GREEN='\033[0;32m'
BLUE='\033[0;34m'

echo "genUp version ${VERSION}"

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

currentOption=""
lastOption=0
default=1

selectOption() {
    echo 
    echo -e "${BOLD}${BLUE}Available options:${RESET}"
    echo -e "\t[1] Update the local portage tree"
    echo -e "\t[2] Update the system"
    echo -e "\t[3] Clean the system"
    echo -e "\t[4] Clean distfiles"
    echo -e "\t[q] Quit"
 
    default=$(($lastOption+1))
    if [ $default -gt 4 ]; then default='q'; fi
    read -p "What do you want to do? [1-4,q] (Default: ${default}) " currentOption
    if [ -z "$currentOption" ]; then currentOption=$default; fi
}

updatePortageTree() {
    echo -e "${GREEN}Updating the portage tree${RESET}"
    eix-sync
    echo -e "${GREEN}Done - Updating the portage tree${RESET}"
}

updateSystem() {
    echo -e "${GREEN}Updating the system${RESET}"
    emerge -avuND --with-bdeps=y @world
    echo -e "${GREEN}Done - Updating the system${RESET}"
}

cleanSystem() {
    echo -e "${GREEN}Cleaning the system${RESET}"
    emerge -av --depclean
    echo -e "${GREEN}Done - Cleaning the system${RESET}"
}

cleanDistfiles() {
    echo -e "${GREEN}Cleaning the distfiles${RESET}"
    eclean-dist -d
    echo -e "${GREEN}Done - Cleaning the distfiles${RESET}"
}


while [ "$currentOption" != "q" ]
do
    selectOption

    case "$currentOption" in
        1)  updatePortageTree               ;;
        2)  updateSystem                    ;;
        3)  cleanSystem                     ;;
        4)  cleanDistfiles                  ;;
        q)  echo -e "${GREEN}Quit${RESET}"
            exit                            ;;
        *)  selectOption                    ;;
    esac

    lastOption=$currentOption
done
