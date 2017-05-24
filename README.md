# carter
#!/bin/bash


#######################################################################
#
# $Name:        oracle_backup.sh
# $Version:     v1.0
# $Function:    Backup Oracle Database Template Script.
# $Author:      Carter Qiu
# $Organization: http://www.cnmc.com.cn
# $Created Date: 2016-12-15
# $Description:  Generation Backup Oracle Database Script.
#                maintenance expired backupset 
# 
#######################################################################


# Shell Env
SHELL_NAME="oracle_backup.sh"
SHELL_DIR="/u01/scripts/rman"
SHELL_LOG="${SHELL_DIR}/${SHELL_NAME}.log"
LOCK_FILE="/tmp/${SHELL_NAME}.lock"

# App Shell Env
ORACLE_HOME=/u01/11.2.0/oracle
ORACLE_SID=CNMCPROD1
PATH=$ORACLE_HOME/bin:$PATH
NLS_LANG=American_america.UTF8
BACKUPSET_DIR="/rman/BACKUPSET"
mkdir -p ${BACKUPSET_DIR}/`date +%Y%m%d`
EXPIRED_DAYS=10
. /u01/11.2.0/oracle/CNMCPROD1_erpdb01.env



# Write Log
shell_log(){
        LOG_INFO=$1
        echo "$(date "+%Y-%m-%d") $(date "+%H-%M-%S") : ${SHELL_NAME} : ${LOG_INFO}" >> ${SHELL_LOG}
}

# Shell Usage
shell_usage(){
        echo $"Usage:$0 {database | archivelog | purge}"        
        
        echo "
Commands:
    database    rman backup oracle datafiles and archived log files 
    archivelog  rman backup all archived log files 
    purge       purge expired backupsets

Run '$0 COMMAND --help' for more information on a command.
"
}

# Shell Lock & Unlock
shell_lock(){
        touch ${LOCK_FILE}
}

shell_unlock(){
        rm -f ${LOCK_FILE}
}


# Backup Oracle Database with archived log files.
database_backup(){
        if [ -f "$LOCK_FILE" ];then
        
                shell_log "${SHELL_NAME} is running"
                echo "${SHELL_NAME} is running" && exit
        fi
        shell_log "${ORACLE_SID} database backup begining, Write log Started"
        shell_lock
        sleep 3
        rman target / cmdfile=database.rcv  log=RMAN_${ORACLE_SID}_DATABASE.log  append
        shell_log "${ORACLE_SID} database backup finished, Write log Stoped"
        shell_unlock
        
}

# Backup Oracle all archived log files.
archivelog_backup(){
        if [ -f "$LOCK_FILE" ];then

                shell_log "${SHELL_NAME} is running"
                echo "${SHELL_NAME} is running" && exit
        fi
        shell_log "${ORACLE_SID} archived log backup begining, Write log Started"
        shell_lock
        sleep 3
        rman target / cmdfile=archivelog.rcv  log=RMAN_${ORACLE_SID}_ARCHIVED_LOG.log  append
        shell_log "${ORACLE_SID} archived log backup finished, Write log Stoped"
        shell_unlock

}

# Purge history expired oracle backupsets.
purge_backupset(){
        if [ -f "$LOCK_FILE" ];then

                shell_log "${SHELL_NAME} is running"
                echo "${SHELL_NAME} is running" && exit
        fi
        shell_log "${ORACLE_SID} purge expired backupset begining, Write log Started"
        shell_lock
        sleep 3
        find ${BACKUPSET_DIR}  -name "*.BAK" -ctime +${EXPIRED_DAYS} -exec rm  -f {} \;
        shell_log "${ORACLE_SID} purge expired backupset finished, Write log Stoped"
        shell_unlock

}


# Main Function
main(){
        case $1 in
                database)
                database_backup
                ;;

                archivelog)
                archivelog_backup
                ;;

                purge)
                purge_backupset
                ;;

                *)
                shell_usage
                ;;
        esac

}

# Exec 
main $1
