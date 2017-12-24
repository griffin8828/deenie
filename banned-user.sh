#!/bin/bash

if [[ $USER != "root" ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
#MYIP=$(wget -qO- ipv4.icanhazip.com);

# get the VPS IP
#ip=`ifconfig venet0:0 | grep 'inet addr' | awk {'print $2'} | sed s/.*://`

#MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
if [ "$MYIP" = "" ]; then
	MYIP=$(wget -qO- ipv4.icanhazip.com)
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";
ether=`ifconfig | cut -c 1-8 | sort | uniq -u | grep venet0 | grep -v venet0:`
if [[ $ether = "" ]]; then
        ether=eth0
fi

#vps="zvur";
vps="aneka";

#if [[ $vps = "zvur" ]]; then
	#source="http://"
#else
	source="https://raw.githubusercontent.com/griffin8828/deenie"
#fi

# go to root
cd

# check registered ip
wget -q -O IP $source/debian7/IP.txt
if ! grep -w -q $MYIP IP; then
	echo "Maaf, hanya IP yang terdaftar yang bisa menggunakan script ini!"
        echo "     
                       
               =============== OS-32 & 64-bit ================
               ♦                                             ♦
               ♦   AUTOSCRIPT CREATED BY YUSUF ARDIANSYAH    ♦
	       ♦                     &                       ♦
	       ♦               DENY SISWANTO                 ♦
               ♦       -----------About Us------------       ♦ 
               ♦            Tel : +6283843700098             ♦
               ♦         { Sms/whatsapp/telegram }           ♦ 
               ♦       http://facebook.com/t34mh4ck3r        ♦    
               ♦   http://www.facebook.com/elang.overdosis   ♦
               ♦                                             ♦
               =============== OS-32 & 64-bit ================
               
                 Please make payment before use auto script
                 ..........................................
                 .        Price: Rp.20.000 = 1IP          .
                 .          *****************             .
                 .           Maybank Account              .
                 .           =================            .
                 .          No   : Hubungi admin          .
                 .          Name : Yusuf Ardiansyah       .
                 ..........................................   
                          Thank You For Choice Us"

	echo "        Hubungi: editor ( elang overdosis atau deeniedoank)"
	
	rm /root/IP
	rm /etc/bin/banned-user.sh
	rm -f /root/IP
	exit
fi


echo "------- ---------- BANNED AKUN SSH --------------------"

	echo "         DEVELOPED BY YUSUF ARDIANSYAH AND ELANG OVERDOSIS            "
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
	echo ""
	read -p "Apakah Anda benar-benar ingin mem-banned akun [$username] [y/n]: " -e -i y BANNED
	if [[ "$BANNED" = 'y' ]]; then
		echo " User : $username" >> /root/banneduser.txt
		passwd -l $username
		echo ""
		echo "Akun [$username] berhasil dibanned!"
	else
		echo ""
		echo "Banned akun [$username] dibatalkan!"
	fi
else
	echo "Username [$username] belum terdaftar!"
	rm -f /root/IP
	exit 1
fi


