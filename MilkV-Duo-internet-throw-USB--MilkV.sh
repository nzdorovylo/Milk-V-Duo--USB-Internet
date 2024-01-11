#! /bin/bash

#### This script provide access  BETWEEN  Milk-V Duo (MilkV) that connected via USB to host device (e.g. RPi 4) AND  private/public Network without RJ45 wires, directly just by USB connection
## You should run two scripts  MilkV-Duo-internet-throw-USB--MilkV.sh  and  MilkV-Duo-internet-throw-USB--RPi4.sh, for one by each device: this script (MilkV-Duo-internet-throw-USB--MilkV.sh) on MilkV  AND  (MilkV-Duo-internet-throw-USB--RPi4.sh) on RPi4
## Scheme
## MilkV <--USB-- RPi4 <--RJ45/WiFi-- Internet --> PC
##
### Works on Linux Core (MilkV official image https://milkv.io/docs/duo/resources/image-sdk  /  https://github.com/milkv-duo/duo-buildroot-sdk/releases/)


### Preconditions:
## USB host should have static IP 192.168.42.21


### Add rc.local file
echo -e "#!/bin/sh
echo Adding route for 192.168.42.21
sleep 2
route add default gw 192.168.42.21
echo Add default finished
exit 0" >> /etc/rc.local
chmod +x /etc/rc.local

##
echo -e "

### Run user scripts
::sysinit:/etc/rc.local" >> /etc/inittab

## Instead above movigs with /etc/rc.local and /etc/inittab you can call below script, but it works juft until you not reboot the board
#route add default gw 192.168.42.21


### Add nameservers
echo -e "nameserver 8.8.8.8" >> /etc/resolv.conf.head


### Finish
echo Configuring Network thow USB on  Milk-V Duo  finished


### Reboot
echo Rebooting...
sleep 2
reboot
exit 0


#########################################################
### Now you albe reach MilkV via SSH:
## directly throw USB port - by usb0 interface
## ssh -p 22 root@192.168.42.1
## or throw another configured host with external IP like 10.0.0.11, but need previously run shell script to configure host device
##ssh -p 2222 root@10.0.0.11
##
### Test Internet connection:
## ping 8.8.8.8 -c 2
#########################################################


### To execute this script run on MilkV:
#su root ./MilkV-Duo-internet-throw-USB--MilkV.sh



### TODO: Set static MAC address, that will be same after rebooting
### TODO: Extract user variable data to bash variables. it can be IPs 192.168.42.1 / 192.168.42.21, usernames root / milkv