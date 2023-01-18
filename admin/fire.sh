#!/bin/bash

# Este script é chamado por /etc/network/interfaces
# v20230118 by Henrique

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

iptables -F
iptables -t nat -F

#BLOQUEANDO TODO O TRAFEGO
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

########################
### Segurança básica ###
########################

# Regra
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags ACK,URG URG -j DROP
iptables -A INPUT -m state --state INVALID -j DROP

iptables -A INPUT -d 224.0.0.0/32 -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -m state --state NEW,ESTABLISHED -m icmp --icmp-type 8 -j ACCEPT
iptables -A INPUT -m state --state NEW -j ACCEPT
iptables -A INPUT -j DROP

iptables -A FORWARD -j DROP

iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -j DROP

# liberar acesso SSH para a organização
iptables -A FORWARD -p tcp -m tcp --dport 22 --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT

# liberar acesso ao MISP para a organização
iptables -A FORWARD -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m multiport --dports 80,443 -j ACCEPT
