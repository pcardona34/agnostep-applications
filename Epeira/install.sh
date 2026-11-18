#!/bin/bash

####################################################
### AGNoStep Apps
### (c) 2026 Patrick Cardona
###
### Thanks for the GNUstep Developers Community
### This is Free and Open Source software.
### Read License in the root directory.
####################################################

################################
### Install Epeira
### A GNUstep Web Browser
################################

################################
### VARS
if [ -z "$DEBUG" ];then
     DEBUG="no" # values: "yes" to debug | "no" to use clean output
     # Should be set in the parent script
fi

SPIN='/-\|'
FIND="YES"
SCRIPTS=../../../SCRIPTS

if [ ! -d ${SCRIPTS} ];then
    echo -e "Bad path: main SCRIPTS folder was not found.\n"
    exit 1
fi

################################
### You must be superuser to install
sudo -v

### Dependencies
#################################
. ./DEPS.ini
if [ "$RENAISSANCE" == "YES" ];then
    check_renaissance
fi

install_deps ${DEBS} || exit 1
sleep 2;clear

###################################
### Misc: Scripts
###################################

### VARS
PREFIX=epeira
TARGET=/usr/local/bin
STR="Dependencies: Scripts"

clear
subtitulo

pushd . >/dev/null
cd build/${REPO} || exit 1
cd Scripts || exit 1

for SCRIPT in xdo bookmark
do

if [ -f ${PREFIX}_${SCRIPT}.sh ];then
	echo -e "\n=== ${SCRIPT} ===\n"	
	chmod +x ${PREFIX}_${SCRIPT}.sh
	sudo cp --verbose --update ${PREFIX}_${SCRIPT}.sh ${TARGET}/${PREFIX}_${SCRIPT}.sh
	ok "Done"
else
	alert "Script ${PREFIX}_${SCRIPT}.sh was not found!"
	exit 1
fi
done
popd >/dev/null
stop

######### end for Misc: Scripts  ################

####################################################
### Misc: Install Epeira Helper
### A socket to embed Surf Web Browser
####################################################

### VARS
####################################################
STR="Epeira Socket Helper"
####################################################
pushd . >/dev/null
cd build/${REPO} ||exit 1
cd Helper || exit 1

clear
subtitlulo

printf "Building...\n"
make clean &>/dev/null
make || exit 1
ok "Done"

printf "Installing...\n"
sudo -E make install
ok "Done"

make clean &>/dev/null

echo -e "\nAll was done for ${STR}.\n"
popd >/dev/null
stop
############### End of Misc: Helper #################

################################
### Install Epeira Conf
### CSS default style
################################

################################
### VARS
STR="Default Style Sheet"
SRC_CSS=surf_default.css
DIR_DEST=$HOME/.surf/styles
#################################

clear
subtitulo

if  [ ! -d $DIR_DEST ];then
     mkdir -p $DIR_DEST
fi

if [ -f ${DIR_DEST}/default.css ];then
    echo "Already done."
else
    pushd . >/dev/null
    cd build/${REPO} || exit 1
    cd Conf
	cp --verbose --update ${SRC_CSS} ${DIR_DEST}/default.css
	ok "Done"
    popd >/dev/null
fi
stop
################# End of Misc: Conf #################

### Build and Install the GNUstep app
clear

echo -e "\nDebug status: $DEBUG"
sleep 1

STR="Purge old release";
subtitulo

pushd . >/dev/null
remove_ifx_app ${APPNAME}
popd >/dev/null
stop

sleep 2
clear
STR="Building and installing ${APP}"
subtitulo

pushd . >/dev/null
cd build/${REPO} || exit 1
_build || exit 1
popd >/dev/null
stop
#################################################
### Service
clear
SERVICE="openURL"
STR="Service: $SERVICE"
subtitulo

printf "Updating Services. Wait...\n"
make_services
ok "Done"

info "All was done for ${APPNAME} and its service ${SERVICE}."
sleep 2
stop
