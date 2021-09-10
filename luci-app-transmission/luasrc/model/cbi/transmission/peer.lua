-- Copyright 2012 Gabor Varga <vargagab@gmail.com>
-- Licensed to the public under the Apache License 2.0.

require("luci.sys")
require("luci.util")

m = Map("transmission")
m.apply_on_parse=true
function m.on_apply(self)
luci.sys.call("/etc/init.d/transmission restart> /dev/null 2>&1")
end
peers=m:section(NamedSection, "peers", "transmission", translate("Peer settings"))
peers.anonymous=true
bind_address_ipv4=peers:option(Value, "bind_address_ipv4", translate("Binding address IPv4"))
bind_address_ipv4.default="0.0.0.0"
bind_address_ipv6=peers:option(Value, "bind_address_ipv6", translate("Binding address IPv6"))
bind_address_ipv6.default="::"
peer_congestion_algorithm=peers:option(Value, "peer_congestion_algorithm", translate("Peer congestion algorithm"))
peer_limit_global=peers:option(Value, "peer_limit_global", translate("Global peer limit"))
peer_limit_per_torrent=peers:option(Value, "peer_limit_per_torrent", translate("Peer limit per torrent"))
peer_socket_tos=peers:option(Value, "peer_socket_tos", translate("Peer socket tos"))

peerport=m:section(NamedSection, "peerport", "transmission", translate("Peer Port settings"))
peerport.anonymous=true
peer_port=peerport:option(Value, "peer_port", translate("Peer port"))
peer_port_random_on_start=peerport:option(Flag, "peer_port_random_on_start", translate("Peer port random on start"))
peer_port_random_on_start.enabled="true"
peer_port_random_on_start.disabled="false"
peer_port_random_high=peerport:option(Value, "peer_port_random_high", translate("Peer port random high"))
peer_port_random_high:depends("peer_port_random_on_start", "true")
peer_port_random_low=peerport:option(Value, "peer_port_random_low", translate("Peer port random low"))
peer_port_random_low:depends("peer_port_random_on_start", "true")
port_forwarding_enabled=peerport:option(Flag, "port_forwarding_enabled", translate("Port forwarding enabled"))
port_forwarding_enabled.enabled="true"
port_forwarding_enabled.disabled="false"

return m
