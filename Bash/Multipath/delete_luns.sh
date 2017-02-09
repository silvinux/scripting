#!/bin/bash
##############################################################################
# Script to delete LUNs from physical server and its alias from multipath.conf
#
# NOTE  - 
#
# Author: Silvio Pérez <silvinux7@gmail.com>
#
##############################################################################
#
# CONSTANTS
#
CP=/usr/bin/cp 
SED=/bin/sed
EGREP=/bin/egrep
CAT=/bin/cat
MV=/bin/mv

#
# FILES
#
LIST_UDEVNAME=list_udevname
LIST_OSNAME=list_osdevice
LIST_WWW=list_wwn
LIST_PATH=list_path_delete
RMDEV_LINENUMBER=linenumber_multipath
MULTIPATH_FILE=multipath.conf
TMPMULTIPATH=tempfile

$CP $LIST_UDEVNAME $LIST_OSNAME 
$SED -i 's,/dev/asmdisk_udev/,ORA-ASM-,g' $LIST_OSNAME
for i in $($CAT $LIST_OSNAME);do $EGREP -n -B2 -A1 $i $MULTIPATH_FILE|$SED 's/^\([0-9]*\).*/\1d/' >> $RMDEV_LINENUMBER;done
$CAT $RMDEV_LINENUMBER|xargs|tr ' ' ';' |xargs $SED $MULTIPATH_FILE -i -e
$CAT $MULTIPATH_FILE| $EGREP -v '^$' > $TMPMULTIPATH;$MV $TMPMULTIPATH $MULTIPATH_FILE
for i in $($CAT $LIST_OSNAME);do multipath -ll $i;done 
for i in $($CAT $LIST_UDEVNAME);do echo $i;done 
for i in $($CAT $LIST_OSNAME);do multipathd show maps| grep  -w $i| awk '{print $3}';done| sort > $LIST_WWW 
for i in $($CAT $LIST_WWW);do multipath -ll $i;done| grep sd| awk -F: '{print $4}'| awk '/sd/{print $2}' > $LIST_PATH 
for i in $($CAT $LIST_PATH);do echo $i;done 
for i in $($CAT $LIST_PATH);do echo 1 > /sys/block/$i/device/delete;done 
for i in $($CAT $LIST_WWW);do multipath -ll $i;done 
for i in $($CAT $LIST_UDEVNAME);do rm -rf $i;done 
multipath -F;multipath 
