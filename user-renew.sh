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

echo "----------------- TAMBAH MASA AKTIF AKUN SSH --------------------" 

	echo "        DEVELOPED BY YUSUF ARDIANSYAH n ELANG OVERDOSIS           " 
echo ""

# begin of user-list
echo "-----------------------------------"
echo "USERNAME              EXP DATE     "  
echo "-----------------------------------"

while read expired
do
	AKUN="$(echo $expired | cut -d: -f1)"
	ID="$(echo $expired | grep -v nobody | cut -d: -f3)"
	exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
	if [[ $ID -ge 1000 ]]; then
		printf "%-21s %2s\n" "$AKUN" "$exp"
	fi
done < /etc/passwd
echo "-----------------------------------"
echo ""
# end of user-list

read -p "Isikan username: " username

egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
	#read -p "Isikan password akun [$username]: " password
	read -p "Berapa hari akun [$username] aktif: " AKTIF
	
	expiredate=$(chage -l $username | grep "Account expires" | awk -F": " '{print $2}')
	today=$(date -d "$expiredate" +"%Y-%m-%d")
	expire=$(date -d "$today + $AKTIF days" +"%Y-%m-%d")
	chage -E "$expire" $username
	passwd -u $username
	#useradd -M -N -s /bin/false -e $expire $username
clear
	
echo -e ""
echo -e "==========================================="
echo -e "|         Informasi Akun Baru SSH         |"  
echo -e "===========[[-SERVER PREMIUM-]]============" 
echo -e "     Host: $MYIP"  
echo -e "     Username: $username"  
echo -e "                                           " 
echo -e "     Port default dropbear: 777,80         "  
echo -e "     Port default SSL/TLS : 443            " 
echo -e "     Port default openSSH : 22,143         " 
echo -e "     Port default squid   : 8080,3128      "  
echo -e "                                           " 
#echo -e "                                           " 
echo -e "-------------------------------------------" 
echo -e "   Aktif Sampai: $(date -d "$AKTIF days" +"%d-%m-%Y")" 
echo -e "===========================================" 
echo -e "   DI LARANG:                              " 
echo -e "   HACKING-DDOS-PHISING-SPAM-TORENT        " 
echo -e "   CARDING-CRIMINAL CYBER.                 " 
echo -e "===========================================" 
echo -e "   Script by Yusuf Ardiansyah              " 
echo -e "   Config OVPN:                            " 
echo -e "   http://$MYIP:81/client.ovpn        "  
echo -e "-------------------------------------------" 
echo -e ""
echo -e ""
else
	echo "Username [$username] belum terdaftar!"
	exit 1
fi


