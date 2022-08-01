#!/bin/bash
net_po=any
#pcap saving path
save_path=/home/deployer/TcpdumpTrafficPackage
#pid
pid_path=/home/deployer/TcpdumpTrafficPackage
#saving format
format=%Y_%m_%d-%H_%M_%S
# time for tcpdump (-G)
th=600
size=0

start_tcpdump()
{
    cd $save_path

    nohup /usr/sbin/tcpdump -i $net_po -s $size -G $th -w "$format".pcap > /dev/null &
    /usr/bin/ps -ef |grep 'tcpdump -i' |grep -v grep |awk '{print $2}' > $pid_path/tcpdumpservice.pid
    num=`/usr/bin/ps -ef |grep 'tcpdump -i' |grep -v grep |wc -l`
    row=`cat $pid_path/tcpdumpservice.pid |wc -l`

    if [ $num == $row ];then
        echo 'tcpdump  started'
    else
        echo "tcpdump is not running or here had some wrong!"
    fi
     stop_tcpdump
}
stop_tcpdump()
{

    sleep $th 
    /usr/bin/kill -9 `cat $pid_path/tcpdumpservice.pid |xargs` > /dev/null
    #echo > $pid_path/tcpdumpservice.pid
    num=`/usr/bin/ps -ef |grep 'tcpdump -i' |grep -v grep |wc -l`
    if [ $num -eq 0 ];then
       echo "tcpdumpservice stop"
    else
       echo "this error"
   fi
}
start_tcpdump

