#! /bin/bash
set +e
 
#modprobe pktgen
 
if [[ `lsmod | grep pktgen` == "" ]];then
   modprobe pktgen
fi

if [[ $1 == "" ]];then
	echo "need a device!"
	exit
else
	devif=$1
fi

if [[ $2 == "" ]];then
   pktsize=1500
else
   pktsize=$2
fi
 
function pgset() {
    local result
 
    echo $1 > $PGDEV
 
    result=`cat $PGDEV | fgrep "Result: OK:"`
    if [ "$result" = "" ]; then
         cat $PGDEV | fgrep Result:
    fi
}
 
function pg() {
    echo inject > $PGDEV
    cat $PGDEV
}
 
# On UP systems only one thread exists -- so just add devices
# We use ens3, ens3
 
PGDEV=/proc/net/pktgen/pgctrl
pgset "reset"

echo "Adding devices to run".
PGDEV=/proc/net/pktgen/kpktgend_1
pgset "rem_device_all"
pgset "add_device $devif"
#pgset "max_before_softirq 1000"
 
# Configure the individual devices
echo "Configuring devices"
 
PGDEV=/proc/net/pktgen/$devif
pgset "clone_skb 1000"
pgset "delay 0"
pgset "pkt_size $pktsize"
pgset "min_pkt_size $pktsize"
pgset "max_pkt_size $pktsize"
#pgset "rate 10G"
pgset "src_mac 90:e2:ba:83:81:85"
pgset "flag IPSRC_RND"
pgset "src_min 192.168.1.11"
pgset "dst 192.168.1.12"
pgset "dst_mac 90:e2:ba:8a:30:11"
pgset "count 0"
 
# Time to run
 
PGDEV=/proc/net/pktgen/pgctrl
echo "pkgsize:$pktsize"
echo "Running... ctrl^C to stop"
 
pgset "start"
 
echo "Done"
