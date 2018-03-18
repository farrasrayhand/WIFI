#!/bin/bash


#
# ~/.bashrc
#

# Warna Terminal

blue='\e[1;34m'
green='\e[0;23m'
purple='\e[1;35m'
cyan='\e[1;36m'
red='\e[1;31m'
coklat='\e[0;33m'
ijo='\e[0;32m'
putih='\e[97m'
itam='\e[0;30m'

### GLOBAL VARIABEL

getInterface=`iwconfig 2>&1 | grep -E 'wl|enp' | awk '{print $1}'`;
fuck='mon'
MACtarget1="--bssid " $getInterface #"mon"
MACtarget2=
Kondisi=

# Animasi Spinner
function spinner {
	
	local pid=$1
	local delay=0.1
	local spinstr='|/-\'
		while [ "$(ps a  | awk '{print $1}' | grep 1)" ]; do
			local temp=${spinstr#?}
			printf " [%c]  " "$spinstr"
			local spinstr=$temp${spinstr%"$temp"}
			sleep $delay
			printf "\b\b\b\b\b\b"
		done
	printf "    \b\b\b\b"
}


### START
clear
spinner
sleep 0.1 && echo -e $cyan	""
sleep 0.1 && echo -e $cyan	"---------------------------"
sleep 0.1 && echo -e $cyan	"[>]	m d v k		| v.1.0 "
sleep 0.1 && echo -e $cyan	"---------------------------"
#spinner"$!"
sleep 0.1 && echo -e $cyan	""
sleep 0.1 && echo -e $red	"List Interface : "
sleep 0.5 && echo -e $cyan	""
sleep 1.0 && echo -e $coklat	"[1]" $getInterface
sleep 0.1 && echo -e $cyan	""
read -p  "~> Select Interface ? [no.] : " prompt

if [[ $prompt == "y" || $prompt == "Y" || $prompt == "1" || $prompt == "Yes" ]]
	then
		airmon-ng start $getInterface
		airodump-ng $getInterface$fuck
		
		
		break;
		

	else
		clear
		airmon-ng stop $getInterface
		echo -e $red	"Visit Me At : http://madevake.blogspot.com/)"
		echo -e $cyan	""
 		exit 0
fi

