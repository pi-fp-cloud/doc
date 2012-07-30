#/etc/network/interfaces

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto br100
iface br100 inet static
	address 172.20.253.191
	netmask 255.255.255.0
	bridge_stp off
	bridge_fd 0
        bridge_ports bond0.60
        bridge_maxwait 0

#auto br100
#iface br100 inet static
#        bridge_ports bond0.60
#        bridge_stp off
#        bridge_fd 0
#        bridge_maxwait 0

auto eth0
iface eth0 inet manual
  bond-master bond0
  pre-up ethtool -s eth0 wol g
  post-down ethtool -s eth0 wol g

auto eth1
iface eth1 inet manual
  bond-master bond0
  pre-up ethtool -s eth1 wol g
  post-down ethtool -s eth1 wol g

auto eth2
iface eth2 inet manual
  bond-master bond0
  pre-up ethtool -s eth2 wol g
  post-down ethtool -s eth2 wol g

auto eth3
iface eth3 inet manual
  bond-master bond0
  pre-up ethtool -s eth3 wol g
  post-down ethtool -s eth3 wol g

#auto eth4
#iface eth4 inet manual
#  bond-master bond0
#  pre-up ethtool -s eth4 wol g
#  post-down ethtool -s eth4 wol g

#auto eth5
#iface eth5 inet manual
#  bond-master bond0
#  pre-up ethtool -s eth5 wol g
#  post-down ethtool -s eth5 wol g

#IMPORTANTE: instalar paquetes ifenslave-... y ethtool, y crear /etc/modprobe.d/bonding.conf con alias bond0 bonding...etc

#Manegement Cloud
auto bond0
iface bond0 inet static
	address 172.20.254.191
	netmask 255.255.255.0
	broadcast 172.20.254.255
	network 172.20.254.0
	gateway 172.20.254.254
	bond-mode 802.3ad
	bond-miimon 100
	bond-lacp-rate 1
	bond-slaves none
	dns-nameservers 172.20.254.104 172.20.254.235
	dns-search iescierva.net

#Public Cloud
auto bond0.60
iface bond0.60 inet manual
	#address 172.20.253.191
	#netmask 255.255.255.0
	#broadcast 172.20.253.255
	#network 172.20.253.0
	vlan-raw-device bond0

#Virtual Cloud
auto bond0.61
iface bond0.61 inet static
	address 172.18.0.191
	netmask 255.255.0.0
	broadcast 172.18.255.255
	network 172.18.0.0
	vlan-raw-device bond0

#Floating Cloud
auto bond0.62
#iface bond0.62 inet manual
iface bond0.62 inet static
	address 172.20.252.191
	netmask 255.255.255.0
	broadcast 172.20.252.255
	network 172.20.252.0
	vlan-raw-device bond0

#SAN
auto bond0.63
iface bond0.63 inet static
	address 172.20.251.191
	netmask 255.255.255.0
	broadcast 172.20.251.255
	network 172.20.251.0
	vlan-raw-device bond0

