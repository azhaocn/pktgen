# pktgen

Pktgen.sh is a script to use Linux pktgen module to generate packet. this example script has been tested on Ubuntu 18.04. 
the script hard code the ip and mac address, please change it as your testing environment. 

# Requirement 
Change the RX and TX setting of the testing NIC.   
>ethtool -C enp68s0f1 rx-usecs 30
>ethtool -G enp68s0f1 rx 4096
>ethtool -G enp68s0f1 tx 4096
>ip link set enp68s0f1 mtu 9014

# Usage
./pktgen.sh enp68s0f1 9000

# Note
Suggested to consider the cpu affinity, and you have to check the NUMA node of the testing NIC.

