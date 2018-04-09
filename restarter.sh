#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# https://github.com/CryptoLions/EOS-Jungle-Testnet
#
# Script since 2009 to control and restart daemons
# please download script for example in folder /opt/restarter.sh
# - add rights for execution: chmod 700 /opt/restarter.sh
# - edit Email data (Lines 18-21), Nodes Pids files and daemon up scripts (Lines 27-33)
# - To Control if restarter.sh is runned every 5 add record to /etc/crontab:  
#     */5 *  * * *  root  /opt/restarter.sh
# - if you dont wont send emails please cooment lines 152 and 156
#
###############################################################################

#----- DAEMONS CHECKER ------
ALERT_EMAIL="your_email_to_notif@someemail.com"
FROM_EMAIL="server@serveremail.io"
SERVER_EMAIL_NAME="serveremail.io"
FROM_NAME="EOS Testnet NO-REPLY"

SERVER_NAME="Node_addr_to_include_in_email"

LOG_FILE="/opt/DaemonsChecker.log"

#if One Daemon control
declare -A DaemonsPIDs=( [nodeos01]='/opt/DAWN3-JUNGLE-01/nodeos.pid' )
declare -A DaemonsRestarters=( [nodeos01]='/opt/DAWN3-JUNGLE-01/start.sh' )

#if more Daemons control
#declare -A DaemonsPIDs=( [nodeos01]='/opt/DAWN3-JUNGLE-01/nodeos.pid' [nodeos02]='/opt/DAWN3-JUNGLE-02/nodeos.pid')
#declare -A DaemonsRestarters=( [nodeos01]='/opt/DAWN3-JUNGLE-01/start.sh' [nodeos02]='/opt/DAWN3-JUNGLE-02/start.sh')

CHECK_INTERVAL=5; #in seconds


# -------------------------------------------
# Initialization Lock File
# -------------------------------------------
PDIR=${0%`basename $0`}
LCK_FILE=$PDIR`basename $0`.lck


# -------------------------------------------
# Am I Running?
# -------------------------------------------
if [ -f "${LCK_FILE}" ]; then

MYPID=`head -n 1 "${LCK_FILE}"`
TEST_RUNNING=`ps -p ${MYPID} | grep ${MYPID}`

if [ -z "${TEST_RUNNING}" ]; then
    #echo "Not running"
    echo $$ > "${LCK_FILE}"
else
    echo "`basename $0` is already running [${MYPID}]"
    exit 0

fi

else
    #echo "Not running"
    echo $$ > "${LCK_FILE}"
fi


#-----------------------------------------------
#---------------- SEND EMAIL -------------------
send_email() {
(
    echo "From: $FROM_EMAIL "
    echo "To: $ALERT_EMAIL "
    echo "MIME-Version: 1.0"
    echo "Content-Type: multipart/alternative; "
    echo ' boundary="some.unique.value.ABC123/'$SERVER_EMAIL_NAME'"'
    echo "Subject: $1"
    echo ""
    echo "This is a MIME-encapsulated message"
    echo ""
    echo "--some.unique.value.ABC123/$SERVER_EMAIL_NAME"
    echo "Content-Type: text/html"
    echo ""
    echo "<html>
    <head>
    <title>$1</title>
    </head>
    <body>
    $2
    </body>
    </html>"
    ) | sendmail -t

}

#-----------------------------------------------
#----------------Script Body--------------------

check_process() {
  #echo "$ts: checking $1"
  #[ "$1" = "" ]  && return 0
  #[ `pgrep -n $1` ] && return 1 || return 0

  [ ! -f ${DaemonsPIDs[$1]} ] && return 0

  pid=$(cat ${DaemonsPIDs[$1]})
  TEST_RUNNING=`ps -p ${pid} | grep ${pid}`
  [ -z "${TEST_RUNNING}" ] && return 0 || return 1

}


declare -A DaemonsPIDsFaults=()


for i in "${!DaemonsPIDs[@]}"
do
  DaemonsPIDsFaults[$i]=0;
done

while [ 1 ]; do

  for i in "${!DaemonsPIDs[@]}"
    do
    #echo "key  : $i"
    #echo "value: ${DaemonsPIDs[$i]}"


    # timestamp
    #ts=`date +%T`
    ts=`date +%d.%m.%y\ %H:%M:%S`


    check_process $i

    if [ $? -eq 0 ]; then
      DaemonsArrFaults[$i]=$((${DaemonsArrFaults[$i]} + 1 ))

      echo "$ts: $i not running, restarting..."


      file_start=${DaemonsRestarters[$i]}

      ${DaemonsRestarters[$i]}
      echo "$ts: DAEMON $i not running, restarting..." >> $PDIR$LOG_FILE

      if [ ${DaemonsArrFaults[$i]} -eq 3 ]; then
        export EMAIL=$FROM_EMAIL
        export REPLYTO=$FROM_EMAIL

        echo "$ts: ALERT! DAEMON $i can't be restartg..." >> $PDIR$LOG_FILE
        subject="DAEMON FAULT: $i"
        body="$ts SERVER $SERVER_NAME ALERT. <BR> DAEMON <B>$i</B> STOPED WORKING AND CAN'T BE RESTARTED! <BR><BR> CHECK SERVER ASAP"
        send_email "$subject", "$body"
      fi
      subject="DAEMON FAULT: $i";
      body="$ts SERVER $SERVER_NAME ALERT. <BR> DAEMON <B>$i</B> STOPED WORKING. TRY TO RESTART! <BR><BR>"
      send_email "$subject", "$body"

    else
      DaemonsArrFaults[$i]=0;
    fi



  done

  sleep $CHECK_INTERVAL
done




# -------------------------------------------
# Cleanup
# -------------------------------------------
rm -f "${LCK_FILE}"

exit 0
