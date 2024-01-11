
# Milk-V Duo. USB Internet
Milk-V Duo. Access to Internet throw USB RNDIS connection to host machine

 This script provide access  *BETWEEN*  **Milk-V Duo** (MilkV) that connected via USB to host device (e.g. RPi 4) *AND*  **private/public Network without RJ45 wires**, directly just by USB connection
 
You should run two scripts  **MilkV-Duo-internet-throw-USB--MilkV.sh**  and  **MilkV-Duo-internet-throw-USB--RPi4.sh**, for one by each device: this script (MilkV-Duo-internet-throw-USB--MilkV.sh) on MilkV  AND  (MilkV-Duo-internet-throw-USB--RPi4.sh) on RPi4

##
 * Scheme
MilkV <--USB-- RPi4 <--RJ45/WiFi-- Internet --> PC

##
 * Works on Linux Core (MilkV official image https://milkv.io/docs/duo/resources/image-sdk
https://github.com/milkv-duo/duo-buildroot-sdk/releases/)

##
**Preconditions**
This is not requied, but preferably to connect Milk-V Duo to host device by USB Type-C and 

**Configurating:**
On Milk-V Duo run script: `su root ./MilkV-Duo-internet-throw-USB--MilkV.sh` - with autoreboot
    
On USB host device (e.g. RPi4) run script: `MilkV-Duo-internet-throw-USB--RPi4.sh` - it`s advisable to reboot after running the scripts.

**Testing:**

- From USB host device (e.g. RPi4):
`ssh -p 22 root@192.168.42.1` - test SSH connection
`sudo iptables -S | grep usb0 -i` - list IP / port forwadring 

connect via UART interface:
> \> `ls /dev/ttyUSB*`
> \> `sudo apt-get install minicom`
> \> `sudo minicom -D /dev/ttyUSB0`

- From Internet / Local Network: `ssh -p 2222 root@10.0.0.11`, where 10.0.0.11 - is USB host device IP address

- From Milk-V Duo:
 `ping 8.8.8.8 -c 2`
  or `wgetcontent=$(wget api.myip.com -q -O -) && echo $wgetcontent`

- On Both machines (Milk-V Duo & RPi4):
 `netstat -rn` or `route` - list routing table
 `ifconfig -a` - check Network Interfaces & devices & PI & MAC & status
 `ip a show usb0`

- How to copy file via SSH to Milc-V Duo: `scp test1.txt root@192.168.42.1:~/`
 
##
TODO:
- Set static MAC address, that will be same after rebooting
- Extract user variable data to bash variables

