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
### Install Birthday
### A Family Events Reminder
################################

################################
### VARS
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

sleep 2;clear

###################################
### Misc: Scripts
###################################

### VARS
TARGET=/usr/local/bin
STR="Dependencies: Scripts"

clear
subtitulo

pushd . >/dev/null
cd build/${REPO} || exit 1
cd Scripts || exit 1

for SCRIPT in birth2vcf feast2ics
do

if [ -f ${SCRIPT} ];then
	echo -e "\n--- ${SCRIPT} ---\n"	
	chmod +x ${SCRIPT}
	sudo cp --verbose --update ${SCRIPT} ${TARGET}/${SCRIPT}
	ok "Done"
else
	alert "Script ${SCRIPT} was not found!"
	exit 1
fi
done
popd >/dev/null
stop

######### end for Misc: Scripts  ################

####################################################
### Misc: Data File Sample
####################################################

STR="Birthday data file...";subtitulo

pushd . >/dev/null
cd build/${REPO} || exit 1
cd Sample || exit 1

DEST_SAMP=$HOME/Documents/Private
if [ ! -d $DEST_SAMP ];then
        mkdir -p $DEST_SAMP
fi
if [ ! -f $DEST_SAMP/Birthdays ];then
    cp --verbose Birthdays.sample $DEST_SAMP/Birthdays
else
    info "We preserve already existing Birthdays file."
fi
popd

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

info "All was done for ${APPNAME}."
sleep 2
stop
