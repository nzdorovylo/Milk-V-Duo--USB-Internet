#! /bin/bash

#### This script provide access  BETWEEN  Milk-V Duo (MilkV) that connected via USB to host device (e.g. RPi 4) AND  private/public Network without RJ45 wires, directly just by USB connection
## You should run two scripts  MilkV-Duo-internet-throw-USB--MilkV.sh  and  MilkV-Duo-internet-throw-USB--RPi4.sh, for one by each device: this script (MilkV-Duo-internet-throw-USB--RPi4.sh) on RPi4  AND  (MilkV-Duo-internet-throw-USB--MilkV.sh) on MilkV
## Scheme
## MilkV <--USB-- RPi4 <--RJ45/WiFi-- Internet --> PC
##
### Works on Debian/Ubuntu


### Preconditions:
## This script tested on Paspberry Pi 4 over Raspberry Pi OS
## RPi4 have two interfaces eth0 - own and usb0 - MilkV RNDIS
## RPi4 can have address like 10.0.0.11, but usb0 192.168.41.1 so this script works for different subnets and address spaces


### Network interfaces Forwarding btw eth0->usb0

sudo sysctl net.ipv4.ip_forward
sudo sysctl -w net.ipv4.ip_forward=1

#############################################################################
## replace 		#net.ipv4.ip_forward=1	->	net.ipv4.ip_forward=1
#	net.ipv4.ip_forward=1			// uncomment in /etc/sysctl.conf 
#	#net.ipv4.ip_forward=1	->	net.ipv4.ip_forward=1

#echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
#sed 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

sysctl_conf=/etc/sysctl.conf
sysctl_conf_row_commented=#net.ipv4.ip_forward=1
sysctl_conf_row_uncommented=net.ipv4.ip_forward=1

grep -q sysctl_conf_row_commented sysctl_conf && (sed -i 's/sysctl_conf_row_commented/sysctl_conf_row_uncommented/' sysctl_conf || echo "sysctl_conf_row_uncommented" >> sysctl_conf)
#############################################################################

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o usb0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i usb0 -o eth0 -j ACCEPT

sudo apt-get update
#sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get -y install iptables-persistent
sudo netfilter-persistent save


### Make static IP for Rpi4 with address 192.168.42.21
echo -e "
interface usb0
static ip_address=192.168.42.21/24
static routers=192.168.42.1
static domain_name_servers=192.168.42.1" >> /etc/dhcpcd.conf

sudo systemctl restart dhcpcd


### IP forwarding for 2222 port.
## So you can connect to MiklV via SSH throw RPi:
## ssh -p 2222 root@10.0.0.11
## where 10.0.0.11 is RPi4 address
# Enable IP forwarding
sudo sysctl -w net.ipv4.ip_forward=1

# Set up port forwarding
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 2222 -j DNAT --to-destination 192.168.42.1:22
sudo iptables -A FORWARD -i eth0 -o usb0 -p tcp --dport 22 -d 192.168.42.1 -j ACCEPT
sudo iptables -A FORWARD -i usb0 -o eth0 -p tcp --sport 22 -s 192.168.42.1 -j ACCEPT


### Finish
echo Configuring Network thow USB on  RPi4 for Milk-V Duo  finished


### Reboot
#echo Rebooting...
#sleep 2
#reboot
exit 0


#########################################################
### Now you albe reach MilkV via SSH:
## directly throw USB port - by usb0 interface
## ssh -p 22 root@192.168.42.1
## or throw another configured host (e.g. RPi4) with external IP like 10.0.0.11, but need previously run shell script to configure MilkV device
##ssh -p 2222 root@10.0.0.11
#########################################################


### To execute this script run on RPi4 (replace root to your useraccount):
#su root ./MilkV-Duo-internet-throw-USB--RPi4.sh


### TODO: Extract user variable data to bash variables. it can be ports 2222, IPs 192.168.42.1 / 10.0.0.11, usernames root / milkv