#!/bin/bash

#######################################################################################
#
# $Name:        iostat.sh
# $Version:     v1.0
# $Function:    Linux/Unix OS Disk Device IO stattistics gather Script.
# $Author:      Carter Qiu
# $Organization: http://www.cnmc.com.cn
# $Created Date: 2017-05-27
# $Description:  Generation Linux/UNIX OS Disk IO monitor Script.
# $Run:          crontab schedule.
#                */5 * * * * cd /u01/app/MOS/bin ; ./iostat.sh >  /dev/null 2>&1  &                          
#                
#
#######################################################################################

# Environment
BASE_DIR="`pwd`/.."
IOSTAT="iostat -d xvda"
OUTPUT="out"
LOG="log"
DATE="`date +%Y-%m-%d`"
OUTPUT_FILE="${BASE_DIR}/${OUTPUT}/IOSTAT_$DATE.out"
HEADER_FILE="${BASE_DIR}/${LOG}/IOSTAT_HEADERS.log"

if [ ! -f ${HEADER_FILE} ]
then
	$IOSTAT | tail -3 | head -1 | awk '{print "Datetime\t" $0}' > ${HEADER_FILE}
fi

COUNTER=1  
while [  $COUNTER -lt 75 ]; do  
#    echo The counter is $COUNTER  
#    vmstat 3 1 |tail -1 |awk '{"date +%Y-%m-%d.%H:%M:%S"|getline d; print d,$0}' >> $OUTPUT_FILE
    $IOSTAT 3 1 | tail -2 | head -1 | awk '{"date +%Y-%m-%d.%H:%M:%S"|getline d; print d,$0}' >> $OUTPUT_FILE
    sleep 3
    let COUNTER=COUNTER+1   
done  

