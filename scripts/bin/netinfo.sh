#! /bin/bash

QUERY0="$(ipconfig getpacket en0)";
QUERY1="$(ipconfig getpacket en1)";
MAC0="$(ifconfig en0 | grep ether | awk '{print $2}')";
MAC1="$(ifconfig en1 | grep ether | awk '{print $2}')";

echo $QUERY0 | grep 'BOOTREPLY' > /dev/null;
ET=$?;

echo $QUERY1 | grep 'BOOTREPLY' > /dev/null;
WI=$?;

echo " ";
echo -e "${COLOR_CYAN}General Info${COLOR_NC}";
echo -e "${COLOR_CYAN}-----------------------${COLOR_NC}";

if [ $ET -eq 0 ] || [ $WI -eq 0 ]
 then
  PUBLIC="$(curl -s http://checkip.dyndns.org | awk '{print $6}' | awk 'BEGIN {FS = "<"} {print $1}')";
  echo -e "Public IP: ${COLOR_GREEN}$PUBLIC${COLOR_NC}";
fi;

echo "Hostname: $HOSTNAME";
echo " ";

echo -e "${COLOR_CYAN}Wired Ethernet (en0)${COLOR_NC}";
echo -e "${COLOR_CYAN}-----------------------${COLOR_NC}";

if [ $ET -eq 0 ]
 then
  echo $QUERY0 | grep 'yiaddr = 0.0.0.0' > /dev/null;
  AT=$?;
  if [ $AT -eq 0 ]
   then
    IP="$(echo $QUERY0 | sed 's/.*ciaddr = \([[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\).*/\1 (Static)/')";
   else
    IP="$(echo $QUERY0 | sed 's/.*yiaddr = \([[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\).*/\1 (DHCP)/')";
  fi;
  SUBNET="$(echo $QUERY0 | sed 's/.*subnet_mask (ip): \([[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\).*/\1/')";
  ROUTER="$(echo $QUERY0 | sed 's/.*router (ip_mult): {\([^}]*\)}.*/\1/')";
  DNS="$(echo $QUERY0 | sed 's/.*domain_name_server (ip_mult): {\([^}]*\)}.*/\1/')";
  SEARCH="$(echo $QUERY0 | sed 's/.*domain_name (string): \(.*\) [[:alpha:]].*/\1/')";
  SPEED="$(ifconfig en0 | grep media: | sed 's/.*(//' | sed 's/ .*//' | sed 's/baseT/ MBit\/s/')";
  echo -e "IP Address:${COLOR_GREEN} $IP${COLOR_NC}";
  echo -e "Subnet Mask:${COLOR_NC} $SUBNET";
  echo -e "Router:${COLOR_NC} $ROUTER";
  echo -e "DNS Server:${COLOR_NC} $DNS";
  echo -e "Search Domains:${COLOR_NC} $SEARCH";
  echo -e "MAC Address:${COLOR_NC} $MAC0";
  echo -e "Speed:${COLOR_NC} $SPEED";
elif ! [ $ET -eq 0 ]
 then
  echo -e "IP Address:${COLOR_RED} inactive${COLOR_NC}";
  echo -e "MAC Address:${COLOR_NC} $MAC0";
fi;

echo " ";
echo -e "${COLOR_CYAN}Wireless Ethernet (en1)${COLOR_NC}";
echo -e "${COLOR_CYAN}-----------------------${COLOR_NC}";

if [ $WI -eq 0 ]
 then
  echo $QUERY1 | grep 'yiaddr = 0.0.0.0' > /dev/null;
  AT=$?;
  if [ $AT -eq 0 ]
   then
    IP="$(echo $QUERY1 | sed 's/.*ciaddr = \([[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\).*/\1 (Static)/')";
   else
    IP="$(echo $QUERY1 | sed 's/.*yiaddr = \([[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\).*/\1 (DHCP)/')";
  fi;
  SUBNET="$(echo $QUERY1 | sed 's/.*subnet_mask (ip): \([[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\).*/\1/')";
  ROUTER="$(echo $QUERY1 | sed 's/.*router (ip_mult): {\([^}]*\)}.*/\1/')";
  DNS="$(echo $QUERY1 | sed 's/.*domain_name_server (ip_mult): {\([^}]*\)}.*/\1/')";
  SEARCH="$(echo $QUERY1 | sed 's/.*domain_name (string): \(.*\) [[:alpha:]].*/\1/')";
  SPEED="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | grep lastTxRate: | sed 's/.*: //' | sed 's/$/ MBit\/s/')";
  echo -e "IP Address:${COLOR_GREEN} $IP${COLOR_NC}";
  echo -e "Subnet Mask:${COLOR_NC} $SUBNET";
  echo -e "Router:${COLOR_NC} $ROUTER";
  echo -e "DNS Server:${COLOR_NC} $DNS";
  echo -e "Search Domains:${COLOR_NC} $SEARCH";
  echo -e "MAC Address:${COLOR_NC} $MAC1";
  echo -e "Speed:${COLOR_NC} $SPEED"
elif ! [ $WI -eq 0 ]
 then
  echo -e "IP Address:${COLOR_RED} inactive${COLOR_NC}";
  echo -e "MAC Address:${COLOR_NC} $MAC1";
fi;

echo " ";