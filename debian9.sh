#!/bin/bash

##
# IntKSetup system installer
#
# Script: install.sh
# Version: I.1.IV
# Author: Doctype <doct.knowledge@gmail.com>
# Description: This script will install all the needed packages to run
#              IntKnowledge Setup on your server.
##

# clear terminal screen
clear

cd ~

## Colors
grey='\e[1;30m'
red='\e[0;31m'
green='\e[0;32m'
noclr='\e[0m'

###############################################
# Questions...
###############################################
ipaddr=""
default=$(curl -4 icanhazip.com);
read -p "Enter IP address [$default]: " ipaddr
ipaddr=${ipaddr:-$default}

keycountry=""
default="US"
read -p "Enter IP address [$default]: " keycountry
keycountry=${keycountry:-$default}

keyprovince=""
default="CA"
read -p "Enter IP address [$default]: " keyprovince
keyprovince=${keyprovince:-$default}

keycity=""
default="SanFrancisco"
read -p "Enter IP address [$default]: " keycity
keycity=${keycity:-$default}

keyorg=""
default="Fort-Funston"
read -p "Enter IP address [$default]: " keyorg
keyorg=${keyorg:-$default}

keyemail=""
default="me@myhost.mydomain"
read -p "Enter IP address [$default]: " keyemail
keyemail=${keyemail:-$default}

keyou=""
default="MyOrganizationalUnit"
read -p "Enter IP address [$default]: " keyou
keyou=${keyou:-$default}

keyname=""
default="EasyRSA"
read -p "Enter IP address [$default]: " keyname
keyname=${keyname:-$default}
###############################################

echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "'||'  '|' '||''|.   .|'''.|    +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+"
echo -e " '|.  .'   ||   ||  ||..  '    |K| |n| |o| |w| |l| |e| |d| |g| |e|"
echo -e "  ||  |    ||...|'   ''|||.    +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+"
echo -e "   |||     ||      .     '||  ${grey}Dicipta oleh Doctype${noclr}"
echo -e "    |     .||.     |'....|'   ${grey}Dikuasai oleh VPS.Knowledge${noclr}"
echo -e "   Linux Debian-9 [32Bit]     ${grey}2019, Hak cipta terpelihara.${noclr}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "This script will do a nearly unattended installation of all"
echo "needed and required software to run IntKnowledge Setup."
echo

# Check if user is root
if [[ "$UID" -ne 0 ]] ; then
echo "${red}You need to run this as root!${noclr}"
    exit 1
fi

# Check connectivity
echo -n "Checking internet connection... "
ping -q -c 3 www.google.com > /dev/null 2>&1
if [ ! "$?" -eq 0 ] ; then
    echo -e "${red}ERROR: Please check your internet connection${NC}"
    exit 1;
fi

# Prompt user to continue with installation
echo "Skrip akan kemas kini, menaik taraf, memasang dan mengkonfigurasi"
echo "semua perisian yang diperlukan untuk menjalankan IntKSetup."
read -p 'Anda pasti ingin teruskan [y/N]? ' choose
if ! [[ "$choose" == "y" || "$choose" == "Y" ]] ; then
    exit 1
fi

cd

echo -n "Updating apt and upgrading currently installed packages... "
apt-get -qq update > /dev/null 2>&1
apt-get -qqy upgrade > /dev/null 2>&1
apt-get -qqy build-essensitial > /dev/null 2>&1
echo -e "[${green}DONE${noclr}]"

echo "Installing basic packages... "
apt-get -qqy install screen debconf-utils binutils git lsb-release > /dev/null 2>&1

echo "dash dash/sh boolean false" | debconf-set-selections
dpkg-reconfigure -f noninteractive dash > /dev/null 2>&1
echo -n "Reconfigure dash... "
echo -e "[${green}DONE${noclr}]"

ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf

cd

# dropbear
echo -n "Installing dropbear package... "
apt-get -qqy install dropbear
echo -e "[${green}DONE${noclr}]"

echo "Configure dropbear conf... "
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=4343/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
echo -e "[${green}DONE${noclr}]"

cd

# squid3
echo "Installing openvpn package... "
apt-get -y install squid3
echo -e "[${green}DONE${noclr}]"

echo "Configure openvpn package... "
cat > /etc/squid3/squid.conf << EOF
# NETWORK OPTIONS.
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16

# local Networks.
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl VPS dst $ipaddr/32

# squid Port
http_port 3128

# Minimum configuration.
http_access allow VPS
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access allow localnet
http_access deny all

# Add refresh_pattern.
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname proxy.vps-knowledge
EOF

echo -e "[${green}DONE${noclr}]"

cd

# openvpn
echo -n "Installing openvpn package... "
apt-get -qqy install openvpn easy-rsa
echo -e "[${green}DONE${noclr}]"

echo "Configure openvpn package... "
cp -r /usr/share/easy-rsa/ /etc/openvpn
mkdir /etc/openvpn/easy-rsa/keys

sed -i 's/export KEY_COUNTRY="US"/export KEY_COUNTRY="$keycountry"/' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_PROVINCE="CA"/export KEY_PROVINCE="$keyprovince"/' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_CITY="SanFrancisco"/export KEY_CITY="$keycity"/' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_ORG="Fort-Funston"/export KEY_ORG="$keyorg"/' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_EMAIL="me@myhost.mydomain"/export KEY_EMAIL="$keyemail"/' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_OU="MyOrganizationalUnit"/export KEY_OU="$keyou"/' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_NAME="EasyRSA"/export KEY_NAME="$keyname"/' /etc/openvpn/easy-rsa/vars

openssl dhparam -out /etc/openvpn/dh2048.pem 2048

cd /etc/openvpn/easy-rsa
cp openssl-1.0.0.cnf openssl.cnf
. ./vars
./clean-all
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --initca $*

export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --server server

export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" client

mkdir /etc/openvpn/keys/
cp /etc/openvpn/easy-rsa/keys/server.crt /etc/openvpn/keys/server.crt
cp /etc/openvpn/easy-rsa/keys/server.key /etc/openvpn/keys/server.key
cp /etc/openvpn/easy-rsa/keys/ca.crt /etc/openvpn/keys/ca.crt

cat > /etc/openvpn/server.conf << EOF
port 1194
proto tcp
dev tun

ca /etc/openvpn/keys/ca.crt
cert /etc/openvpn/keys/server.crt
key /etc/openvpn/keys/server.key
dh /etc/openvpn/keys/dh2048.pem

plugin /usr/lib/openvpn/openvpn-auth-pam.so /etc/pam.d/login
client-cert-not-required
username-as-common-name

server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
duplicate-cn
cipher AES-256-CBC
keepalive 10 120
user nobody
group nogroup
persist-key
persist-tun
status vpn-status.log
log vpn-log.log
comp-lzo
verb 3
mute 20
EOF

cat > /etc/openvpn/client.ovpn << EOF
client
dev tun
proto tcp
remote $ipaddr 1194
resolv-retry infinite
ns-cert-type server
nobind
user nobody
group nogroup
persist-key
persist-tun

cipher AES-256-CBC
mute-replay-warnings
auth-user-pass
comp-lzo
verb 3
mute 20

http-proxy-retry
http-proxy [squid] [port]
http-proxy-option CUSTOM-HEADER Host [host]
http-proxy-option CUSTOM-HEADER X-Online-Host [host]
EOF

echo '' >> /etc/openvpn/client.ovpn
echo '<ca>' >> /etc/openvpn/client.ovpn
cat /etc/openvpn/keys/ca.crt >> /etc/openvpn/client.ovpn
echo '</ca>' >> /etc/openvpn/client.ovpn

echo -e "[${green}DONE${noclr}]"

cd

# stunnel4
echo -n "Installing stunnel4 package... "
apt-get -qqy install stunnel4
echo -e "[${green}DONE${noclr}]"

echo -n "Configure stunnel4 package... "
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -sha256 -subj '/CN=127.0.0.1/O=localhost/C=MY' -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem

cat > /etc/stunnel/stunnel.conf << EOF
sslVersion = all
pid = /stunnel.pid
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
client = no

[dropbear]
accept = $ipaddr:443
connect = 127.0.0.1:4343
cert = /etc/stunnel/stunnel.pem
EOF

service stunnel4 restart
echo -e "[${green}DONE${noclr}]"

cd

# openssh
echo "Configure openssh conf... "
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 2020' /etc/ssh/sshd_config
echo -e "[${green}DONE${noclr}]"

# # badvpn-udpgw
# echo -n "Downloading badvpn package from source... "
# wget -O /usr/bin/badvpn-udpgw "https://github.com/ndiey/Packages/raw/master/badvpn-udpgw"
# echo -e "[${green}DONE${noclr}]"
#
# echo -n "Configure badvpn package... "
# chmod +x /usr/bin/badvpn-udpgw
## badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300
# screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300
# echo -e "[${green}DONE${noclr}]"

cd

# fail2ban
echo -n "Installing fail2ban package... "
apt-get -qqy install fail2ban
service fail2ban restart
echo -e "[${green}DONE${noclr}]"

cd

# iptables
echo -n "Installing iptables package... "
apt-get -qqy install iptables
echo -e "[${green}DONE${noclr}]"

echo "Configure iptables package... "
cat > /etc/iptables.up.rules << EOF
*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
COMMIT

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -p ICMP --icmp-type 8 -j ACCEPT
-A INPUT -p tcp --dport 53 -j ACCEPT
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT
-A INPUT -p tcp --dport 22 -j ACCEPT
-A INPUT -p tcp --dport 2020 -j ACCEPT
-A INPUT -p tcp --dport 4343 -j ACCEPT
-A INPUT -p tcp --dport 1194 -j ACCEPT
-A INPUT -p tcp --dport 3128 -j ACCEPT
-A INPUT -p tcp --dport 8888 -j ACCEPT
-A INPUT -p tcp --dport 7300 -j ACCEPT
-A INPUT -p tcp --dport 10000 -j ACCEPT
COMMIT

*mangle
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
EOF

iptables-restore < /etc/iptables.up.rules
echo -e "[${green}DONE${noclr}]"

# # command script
# wget -O /usr/bin/menu "$PWD/functions/main_menu.sh"
# wget -O /usr/bin/01 "$PWD/functions/trial_account.sh"
# wget -O /usr/bin/02 "$PWD/functions/create_account.sh"
# wget -O /usr/bin/03 "$PWD/functions/renew_account.sh"
# wget -O /usr/bin/04 "$PWD/functions/change_password.sh"
# wget -O /usr/bin/05 "$PWD/functions/lock_account.sh"
# wget -O /usr/bin/06 "$PWD/functions/unlock_account.sh"
# wget -O /usr/bin/07 "$PWD/functions/delete_account.sh"
# wget -O /usr/bin/08 "$PWD/functions/list_account.sh" #Error!
# wget -O /usr/bin/09 "$PWD/functions/online_account.sh" #Error!
# wget -O /usr/bin/10 "$PWD/functions/speedtest_cli.py"
# wget -O /usr/bin/11 "$PWD/functions/system_info.sh"
#
# chmod +x /usr/bin/menu
# chmod +x /usr/bin/01
# chmod +x /usr/bin/02
# chmod +x /usr/bin/03
# chmod +x /usr/bin/04
# chmod +x /usr/bin/05
# chmod +x /usr/bin/06
# chmod +x /usr/bin/07
# chmod +x /usr/bin/08
# chmod +x /usr/bin/09
# chmod +x /usr/bin/10
# chmod +x /usr/bin/11

# restart pakages service
apt-get -qqy autoremove
service ssh restart
service openvpn restart
service dropbear restart
service squid3 restart
service badvpn-udpgw restart
service stunnel4 restart
service fail2ban restart

# final step
echo "You need [reboot] server to complete this setup."
