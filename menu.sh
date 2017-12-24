#!/bin/bash
rm /root/IP
clear

# get the VPS IP
#ip=`ifconfig venet0:0 | grep 'inet addr' | awk {'print $2'} | sed s/.*://`
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
if [ "$MYIP" = "" ]; then
	MYIP=$(wget -qO- ipv4.icanhazip.com)
fi
#myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;

flag=0

echo

	#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
	#if [ "$MYIP" = "" ]; then
		#MYIP=$(wget -qO- ipv4.icanhazip.com)
	#fi

	clear

	
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	
cat /usr/bin/bannermenu  
echo "                    Server: $MYIP"  
date +"                    %A, %d-%m-%Y"  
date +"                            %H:%M:%S %Z" 
echo ""
echo ""
PS3='Silahkan ketik nomor pilihan anda lalu tekan ENTER: '
options=("Buat User SSH/OVPN" "Buat User SSH/OVPN Trial" "Perbarui User" "Ganti Password User SSH/OVPN" "Semua User Dan Tanggal Kadaluarsa" "Hapus User" "Buat User PPTP VPN" "Monitor User Login" "Daftar User Aktif" "Daftar User Kadaluarsa" "Disable User Kadaluarsa" "Hapus User Kadaluarsa" "Banned User" "Unbanned User" "Penggunaan Ram" "Speedtest" "Benchmark" "Manual Kill Multi Login" "(ON)AutoKill Multi Login" "(OFF)AutoKill Multi Login" "Ganti Password VPS" "Bersihkan Cache Ram Manual" "Edit Banner Login" "Edit Banner Menu" "Lihat Lokasi User" "Restart Webmin" "Restart Server VPS" "Restart Dropbear" "Restart OpenSSH" "Restart Squid3" "Restart OpenVPN" "Restart SSL" "Ganti Port OpenSSH" "Ganti Port Dropbear" "Ganti Port Squid3" "Ganti Port OpenVPN" "Update Script VPS" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Buat User SSH/OVPN")
	clear
        user-add
        break
            ;;
	"Buat User SSH/OVPN Trial")
	clear
	user-gen
	break
	;;
	"Perbarui User")
	clear
	user-renew
	break
	;;
	"Ganti Password User SSH/OVPN")
	clear
	user-pass
	break
	;;
	"Semua User Dan Tanggal Kadaluarsa")
	clear
	user-list 
	break
	;;
	"Hapus User")
	clear
	user-del
	break
	;;
	"Buat User PPTP VPN")
	clear
	user-add-pptp 
	break
	;;
	"Monitor User Login")
	clear
	dropmon
	break
	;;
	"Manual Kill Multi Login")
	clear
        read -p "Isikan Maximal User Login (1-2): " MULTILOGIN
        userlimit.sh $MULTILOGIN
	#userlimitssh.sh $MULTILOGIN
	break
	;;
	"(ON)AutoKill Multi Login")
	clear 
	read -p "Isikan Maximal User Login (1-2): " MULTILOGIN2
	echo "@reboot root /root/userlimit.sh" > /etc/cron.d/userlimitreboot
	service cron stop
	echo "* * * * * root /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit1
	   echo "* * * * * root sleep 10; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit2
           echo "* * * * * root sleep 20; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit3
           echo "* * * * * root sleep 30; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit4
           echo "* * * * * root sleep 40; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit5
           echo "* * * * * root sleep 50; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit6
	   #:echo "@reboot root /root/userlimitssh.sh" >> /etc/cron.d/userlimitreboot
	  # echo "* * * * * root /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit1
	  # echo "* * * * * root sleep 11; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit2
          # echo "* * * * * root sleep 21; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit3
           #echo "* * * * * root sleep 31; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit4
          # echo "* * * * * root sleep 41; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit5
           #echo "* * * * * root sleep 51; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit6
	    service cron start
	    service cron restart
	    service ssh restart
	    service dropbear restart
	    echo "------------+ AUTO KILL SUDAH DI AKTIFKAN BOSS +--------------"  
	    
	echo "Dasar pelit!!! user ente marah2 jangan salahkan ane ya boss¡¡¡
nanti jangan lupa di matikan boss
biar user senang bs multilogin lagi.."  
	break
	;;
	"(OFF)AutoKill Multi Login")
	clear
	service cron stop
	rm -rf /etc/cron.d/userlimit1
	rm -rf /etc/cron.d/userlimit2
	rm -rf /etc/cron.d/userlimit3
	rm -rf /etc/cron.d/userlimit4
	rm -rf /etc/cron.d/userlimit5
	rm -rf /etc/cron.d/userlimit6
	#rm -rf /etc/cron.d/userlimitreboot
	service cron start
	service cron restart
	    service ssh restart
	    service dropbear restart
	clear
	echo ""
	echo "AUTO KILL LOGIN,SUDAH SAYA MATIKAN BOS 
User Sudah Bisa Multi Login Lagi!!!" 
	break
	;;
	"Ganti Password VPS")
	clear
	read -p "Silahkan isi password baru untuk VPS anda: " pass	
        echo "root:$pass" | chpasswd
	echo "Ciieeee.. Ciieeeeeee.. Abis Ganti Password VPS Nie Yeeee...!!!"  
	break
	;;
	"Bersihkan Cache Ram Manual")
	clear
	echo "---------------------------------------------" 
	echo "Sebelum..."  
	echo "---------------------------------------------" 
       free -h
	echo 1 > /proc/sys/vm/drop_caches
	sleep 1
	echo 2 > /proc/sys/vm/drop_caches
	sleep 1
	echo 3 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a
	sleep 1
	echo "---------------------------------------------" 
	echo "Sesudah..."  
	echo "---------------------------------------------" 
	free -h
	echo "---------------------------------------------" 
	echo "SUKSES..!!!Cache ram anda sudah di bersihkan."  
        echo ""
	break
	;;
	"Daftar User Aktif")
	clear
	user-active-list 
	break
	;;
	"Daftar User Kadaluarsa")
	clear
	user-expire-list 
	break
	;;
	"Disable User Kadaluarsa")
	clear
	disable-user-expire
	break
	;;
	"Hapus User Kadaluarsa")
	clear
	delete-user-expire
	break
	;;
	"Banned User")
	clear
	banned-user
	break
	;;
	"Unbanned User")
	clear
	unbanned-user
	break
	;;
	"Penggunaan Ram")
	clear
	ps-mem  | lolcat
	break
	;;
	"Speedtest")
	clear
	echo ""
	echo "SPEEDTEST SERVER" 
	echo "-----------------------------------------"
	speedtest --share  
	echo "-----------------------------------------"
	break
	;;
	"Benchmark")
	clear
	echo ""
	echo ""
	echo "     #----------BENCHMARK-----------#" 
	benchmark
	break
	;;
        "Edit Banner Login")
	clear
	echo "-----------------------------------------------------------" 
	echo -e "1.) Simpan text          = (CTRL + X, lalu ketik Y dan tekan Enter) " 
	echo -e "2.) Membatalkan edit text= (CTRL + X, lalu ketik N dan tekan Enter)" 
	echo "-----------------------------------------------------------" 
	read -p "Tekan ENTER untuk melanjutkan........................ " 
	nano /bannerssh
	service dropbear restart && service ssh restart
	break
	;;
	"Edit Banner Menu")
	clear
	echo "--------------------------------------------------------" 
	echo -e "1. Simpan text          = (CTRL + X, lalu ketik Y dan tekan ENTER)" 
	echo -e "2. Membatalkan edit text= (CTRL + X,lalu ketik N dan tekan ENTER)" 
	echo "--------------------------------------------------------" 
	read -p "Tekan ENTER untuk melanjutkan..................." 
	nano /usr/bin/bannermenu
	break
	;;
	"Lihat Lokasi User")
	clear
	user-login
	echo "Contoh: 112.123.345.126 lalu Enter" 
        read -p "Ketik Salah Satu Alamat IP User: " userip
        curl ipinfo.io/$userip
	echo "-----------------------------------" 
        break
	;;
	"Restart Webmin")
	clear
	 service webmin restart
	 echo "Webmin sudah di restart boss!!!" 
	 break
	 ;;
	 "Restart Server VPS")
	 clear
	 reboot
	 echo "Sudah di restart tunggu sebentar ya boss!!!" 
	 echo "Sebentar lagi CONSOLE akan log out" 
	 break
	 ;;
	 "Restart Dropbear")
	 clear
	 service dropbear restart
	 echo "Dropbear sudah di restart boss!!!" 
	 break
	 ;;
	 "Restart OpenSSH")
	 clear
	 service ssh restart
	 echo "OpenSSH sudah di restart boss!!!" 
	 break
	 ;;
	 "Restart OpenVPN")
	 clear
	 service openvpn restart
	 echo "openvpn sudah di restart boss!!!" 
	 break
	 ;;
	  "Restart SSL")
	 clear
	 service stunnel4 restart
	 echo "stunnel4/ssl sudah di restart boss!!!" 
	 break
	 ;;
	 
	 "Restart Squid3")
	 clear
	 service squid3 restart
	 echo "Squid3 sudah di restart boss!!!" 
	 break
	 ;;
	 "Ganti Port OpenSSH")
	 clear
	 echo ""
            echo "Silahkan ganti port Openssh anda lalu klik enter."
            echo "Port default dan Port 2 tidak boleh sama !!!" 
	    echo "Port default: 22"
	    read -p "Port 2: " -e -i 143 PORT
	    service dropbear stop
	    service ssh stop
	    service openvpn stop
	    sed -i "6s/Port [0-9]*/Port $PORT/" /etc/ssh/sshd_config
           service ssh start 
	   service dropbear start
	   service openvpn start
            echo "Openssh Updated Port: $PORT"
	 break
         ;;
	 "Ganti Port Dropbear")
	 clear
            echo "Silahkan ganti port Dropbear anda lalu klik ENTER!!!
Port dropbear tidak boleh sama dengan port openVPN/openSSH/squid3 !!!" 
           echo "Port1: 777 (Default)"
	    read -p "Port2: " -e -i 80 PORT
	    service dropbear stop
	    service ssh stop
	    service openvpn stop
            sed -i "s/DROPBEAR_PORT=[0-9]*/DROPBEAR_PORT=$PORT/g" /etc/default/dropbear
	    #sed -i 's/DROPBEAR_EXTRA_ARGS="-p [0-9]*"/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear	
            service dropbear start
	    service ssh start
	    service openvpn start
            echo "Dropbear Updated Port2 : $PORT"
	    #echo "Dropbear Updated : Port2 $PORT2"
	    #echo "Dropbear Updated : Port3 $PORT3" 
	 break
	 ;;
	 "Ganti Port Squid3")
	 clear
	 echo "Silahkan ganti port Squid3 anda lalu klik enter"
	    echo "Isi dengan angka tidak boleh huruf !!!"
	    echo -e "Port Squid3 1: 8080"
	    read -p "Port Squid3 2: " -e -i 3128 PORT
            #sed -i 's/http_port [0-9]*\nhttp_port [0-9]*/http_port $PORT1\nhttp_port $PORT2/g' /etc/squid3/squid.conf
            sed -i "23s/http_port [0-9]*/http_port $PORT/" /etc/squid3/squid.conf
	   service squid3 restart
            echo "Squid3 Updated Port: $PORT"
			break
			;;
			"Speedtest")
			clear
			python speedtest.py --share
			break		
	 ;;
	 "Ganti Port OpenVPN")
	 clear
	 echo ""
	           echo "Silahkan ganti port OpenVPN anda lalu klik enter?"
            read -p "Port: " -e -i 55 PORT
	    service dropbear stop
	    service ssh stop
	    service openvpn stop
            sed -i "s/port [0-9]*/port $PORT/g" /etc/openvpn/1194.conf
	   # cp /etc/openvpn/client.ovpn /home/vps/public_html/client.ovpn
           # sed -i "s/ipserver ports/$MYIP $PORT/g" /home/vps/public_html/client.ovpn
	   # sed -i "s/ipserver/$MYIP/g" /home/vps/public_html/client.ovpn
	   service openvpn start
	    service dropbear start
	    service ssh start
	 break
	 ;;
	 "Update Script VPS")
	 clear
	 /usr/bin/menu-update-script-vps.sh
	 break
	 ;;
	"Quit")
	
	break
	;;
	 
        *) echo invalid option;
	esac
done
