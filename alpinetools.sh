#!/bin/bash
#By: Silva
#Project for X102BA
main() {
	clear
	ex=0
	#add community repo
	echo -ne "\t Welcome!
         Alpine Kali Tools
         Community repository needs activity
         Is it activated? (Y or N):"
	read active_C
	#functions for add repositories
	community() {
		apk upgrade && apk update
		echo "http://dl-cdn.alpinelinux.org/alpine/v3.21/community" >>/etc/apk/repositories
		apk upgrade && apk update
		clear
		echo -e "\t add sucess\n"
		sleep 2
		clear
	}
	edge() {
		apk upgrade && apk update
		echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >>/etc/apk/repositories
		apk upgrade && apk update
		clear
		echo -e "\t add sucess\n"
		sleep 2
		clear
	}
	meta() {
		apk add build-base ruby ruby-bigdecimal ruby-bundler ruby-io-console ruby-webrick ruby-dev libffi-dev openssl-dev readline-dev sqlite-dev postgresql-dev libpcap-dev libxml2-dev libxslt-dev yaml-dev zlib-dev ncurses-dev autoconf bison subversion sqlite nmap libxslt postgresql ncurses
		cd /opt/ && git clone https://github.com/rapid7/metasploit-framework.git && cd metasploit-framework && gem install bundler && bundle update && bundle install
		ln -sf ${PREFIX}/opt/metasploit-framework/msfconsole ${PREFIX}/bin/
		ln -sf ${PREFIX}/opt/metasploit-framework/msfvenom ${PREFIX}/bin/
		ln -sf ${PREFIX}/opt/metasploit-framework/msfrpcd ${PREFIX}/bin/

	}

	if [ "$active_C" = "Y" -o "$active_C" = "y" ]; then
		community
	else
		if [ "$active_C" = "N" -o "$active_C" = "n" ]; then
			echo "No activad"
			sleep 2
			clear
		else
			ex=2
		fi
	fi
	#add testing repo
	if [ "$ex" = 0 ]; then
		echo -ne "\t  Edge repository needs activity
                Is it activated? (Y or N):"
		read active_E
		if [ "$active_E" = "Y" -o "$active_E" = "y" ]; then
			edge
		else
			if [ "$active_E" = "N" -o "$active_E" = "n" ]; then
				echo "No activad"
				sleep 2
				clear
			else
				ex=2
			fi
		fi
		if [ "$ex" = 0 ]; then
			ex=1
			while [ "$ex" = 1 ]; do
				#selection option
				echo -ne "\t Kali tools\n 
         1) Nmap
         2) Gobuster
         3) Hydra
	 4) Wireshark
  	 5) Metasploit
    	 6) Ffuf
         0) Exit\n
         select the tool you want to install: "
				read op
				#Program installer according to the option
				case "$op" in
				0)
					ex=0
					;;
				1)
					apk add nmap && apk upgrade && apk update && clear && echo -e "\t add nmap" && sleep 2 && clear
					;;
				2)
					apk add gobuster@testing && apk upgrade && apk update && clear && echo -e "\t add gobuster" && sleep 2 && clear
					;;
				3)
					apk add hydra && apk upgrade && apk update && clear && echo -e "\t add hydra" && sleep 2 && clear
					;;
				4)
					apk add wireshark && apk upgrade && apk update && clear && echo -e "\t add wireshark" && sleep 2 && clear
					;;
				5)
					meta && apk upgrade && apk update && clear && echo -e "\t add Metasploit" && sleep 2 && clear
					;;
				6)
					apk add ffuf && apk upgrade && apk update && clear && echo -e "\t add ffuf" && sleep 2 && clear
					;;

				esac
			done
		fi
	fi
	#invalid operation
	if [ "$ex" = 2 ]; then
		echo "Invalid operation!"
	fi
}
main
