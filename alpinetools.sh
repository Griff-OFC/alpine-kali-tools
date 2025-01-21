#!/bin/bash
#By: Silva
#Project for X102BA
 main () {
  clear
  flag=0;
#add community repo
 echo -ne "\t Welcome!
 	 Alpine Kali Tools
	 Community repository needs activity
	 Is it activated? (Y or N):";
	 read active_C;
#functions for add repositories
 community () {
	apk upgrade && apk update
	echo "http://dl-cdn.alpinelinux.org/alpine/v3.21/community" >> /etc/apk/repositories
	apk upgrade && apk update
	echo "add sucess"
	sleep 2
	clear
 }
  edge () {
	apk upgrade && apk update
	echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
	apk upgrade && apk update
	echo "add sucess"
	sleep 2
	clear
  }
	if [ "$active_C" = "Y" -o "$active_C" = "y" ];then
	 community
	else
	if [ "$active_C" = "N" -o "$active_C" = "n" ];then
	echo "No activad";
	sleep 2;
	clear
	else
	 flag=1;
      fi
     fi
#add testing repo
  echo -ne "\t  Edge repository needs activity
		Is it activated? (Y or N):";
		read active_E
	 if [ "$active_E" = "Y" -o "$active_E" = "y" ];then
	  edge
	else 
	 if [ "$active_E" = "N" -o "$active_E" = "n" ];then
	echo "No activad";
	else
	flag=1;
fi
 fi
#selection option
echo -ne "\t kali tools\n 
	 1) nmap
	 2) gobuster
	 3) hydra
	 0) exit\n
	 select the tool you want to install: ";
	read op;
#Program installer according to the option
		case "$op" in
		  1)
		    apk add nmap && apk upgrade && apk update && clear;;
esac
#invalid operation
		if [ "$flag" = 1 ];then
		 echo "invalid operation!";
	fi
	}
main
