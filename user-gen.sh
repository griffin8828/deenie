#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

# get the VPS IP
#ip=`ifconfig venet0:0 | grep 'inet addr' | awk {'print $2'} | sed s/.*://`
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
if [ "$MYIP" = "" ]; then
	MYIP=$(wget -qO- ipv4.icanhazip.com)
fi
#MYIP=$(wget -qO- ipv4.icanhazip.com)

echo "-------------------------- GENERATE  AKUN SSH ---------------------------" 


	echo "           DEVELOPED BY YUSUF ARDIANSYAH N ELANG OVERDOSIS          " 

echo ""

read -p "Berapa hari akun aktif: " AKTIF

	uname=trial-`</dev/urandom tr -dc X-Z0-9 | head -c4`
	masaaktif="$AKTIF"
	pass=`</dev/urandom tr -dc a-f0-9 | head -c9`
	clear

clear
echo -e ""
echo -e ""
echo -e ""
echo -e ""
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $uname
exp="$(chage -l $uname | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$pass\n$pass\n"|passwd $uname &> /dev/null
echo -e ""
echo -e "==========================================="
echo -e "|        Informasi Akun Baru SSH          |"  
echo -e "===========-[[SERVER-PREMIUM]]-============" 
echo -e "     Host: $MYIP"  
echo -e "     Username: $uname"  
echo -e "     Password: $pass                       "  
echo -e "     Port default dropbear: 777,80         "  
echo -e "     Port default SSL/TLS : 443            " 
echo -e "     Port default openSSH : 22,143         " 
echo -e "     Port default squid   : 8080,3128      "  
echo -e "                                           "  
echo -e "     Auto kill user maximal login 2        "  
echo -e "-------------------------------------------" 
echo -e "     Aktif Sampai: $exp                    "  
echo -e "===========================================" 
echo -e "   DI LARANG:                              " 
echo -e "   HACKING-DDOS-PHISING-SPAM-TORENT        "  
echo -e "   CARDING-CRIMINAL CYBER.                 " 
echo -e "===========================================" 
echo -e "   Script by Yusuf Ardiansyah              " 
echo -e "   Config OVPN:                            " 
echo -e "   http://$MYIP:81/client.ovpn             " 
echo -e "-------------------------------------------"
echo -e ""
echo -e ""
