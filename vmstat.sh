#!/bin/bash

#######################################################################################
#
# $Name:        vmstat.sh
# $Version:     v1.0
# $Function:    Linux/Unix OS VMSTAT stattistics gather Script.
# $Author:      Carter Qiu
# $Organization: http://www.cnmc.com.cn
# $Created Date: 2017-05-27
# $Description:  Generation Linux/UNIX OS VMSTAT monitor Script.
# $Run:          crontab schedule.
#                */5 * * * * cd /u01/app/MOS/bin ; ./vmstat.sh >  /dev/null 2>&1  &                          
#                
#
#######################################################################################

# Environment
BASE_DIR="`pwd`/.."
VMSTAT=vmstat
OUTPUT="out"
LOG="log"
DATE="`date +%Y-%m-%d`"
OUTPUT_FILE="${BASE_DIR}/${OUTPUT}/VMSTAT_$DATE.out"
HEADER_FILE="${BASE_DIR}/${LOG}/VMSTAT_HEADERS.log"

if [ ! -f ${HEADER_FILE} ]
then
        ${VMSTAT} |tail -2|head -1|awk '{print "D", $0}' > ${HEADER_FILE}
fi


COUNTER=1
while [  $COUNTER -lt 75 ]; do  
#    echo The counter is $COUNTER  
    vmstat 3 1 |tail -1 |awk '{"date +%Y-%m-%d.%H:%M:%S"|getline d; print d,$0}' >> $OUTPUT_FILE
    sleep 3
    let COUNTER=COUNTER+1   
done  

#--------------------------------------------------------------------------------------------------
# just use for linux platform,  Carter qiu  2017-11-28
#!/bin/bash

DATE=`date +%Y%m%d`
NODENAME=`hostname`
OUTPUT=$NODENAME.$DATE.vmstat


#header= c('procs_r','procs_b','memory_swpd','memory_free','memory_inact','memory_active','swap_si','swap_so','io_bi','io_bo','system_in','system_cs','cpu_us','cpu_sy','cpu_id','cpu_wa','cpu_st','timestamp')
vmstat -t -a -Sm 5 17200 > OUTPUT/$OUTPUT
