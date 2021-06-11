## Sc 01

Configure all nodes in a network to use the gateway 10.0.0.1 for DNS.
But the gateway will not run a DNS service (nothing will listen on port 53),
instead, use the firewall to redirect DNS requests from 10.0/16 to 8.8.8.8.

--------

- Enable routing on the gateway
- Enable masquerading for 10.0/16 addresses on eth0 (can reach 8.8.8.8): 
  `iptables -t nat -A POSTROUTING -s 10.0/16 -o eth0 -j MASQUERADE`
- DNAT DNS packets comming from 10.0/16 to point to 8.8.8.8 as destination:
  `iptables -t nat -A PREROUTING -i eth1 -s 10.0/16 -p udp --dport 53 -j DNAT --to-destination 8.8.8.8`

## Sc 02


