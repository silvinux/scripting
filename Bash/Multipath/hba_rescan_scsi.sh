#!/bin/bash 
# 
# GET LIST TARGETs
echo '--------------------------------------------------------------------------------------------' 
echo 'GET LIST TARGETS' 
echo '--------------------------------------------------------------------------------------------' 
echo 'Scaning started...'
echo '--------------------------------------------------------------------------------------------' 
HOSTPATH='/sys/class/scsi_host' 
for i in $(ls $HOSTPATH) 
do 
	echo "- - -" > $HOSTPATH/$i/scan
	echo "SCANNING --> $HOSTPATH/$i/scan"
done 
