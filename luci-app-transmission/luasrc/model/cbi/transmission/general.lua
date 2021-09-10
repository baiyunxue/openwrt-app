-- Copyright 2012 Gabor Varga <vargagab@gmail.com>
-- Licensed to the public under the Apache License 2.0.

require("luci.sys")
require("luci.util")

m = Map("transmission","",translate("Transmission daemon is a simple bittorrent client, here you can configure the settings."))
m.apply_on_parse=true
function m.on_apply(self)
luci.sys.call("/etc/init.d/transmission restart> /dev/null 2>&1")
end
m:section(SimpleSection).template  = "transmission/transmission_status"
s=m:section(NamedSection, "general", "transmission", translate("Global settings"))
s.addremove=false
s.anonymous=true
enable=s:option(Flag, "enabled", translate("Enabled"))
enable.rmempty=false
config_dir=s:option(Value, "config_dir", translate("Config file directory"))
user=s:option(ListValue, "user", translate("Run daemon as user"))
local p_user
for _, p_user in luci.util.vspairs(luci.util.split(luci.sys.exec("cat /etc/passwd | cut -f 1 -d :"))) do
	user:value(p_user)
end
cache_size_mb=s:option(Value, "cache_size_mb", translate("Cache size in MB"))
web_home=s:option(Value, "web_home", translate("Custom WEB UI directory"))

rpc=m:section(NamedSection, "rpc", "transmission", translate("RPC settings"))
rpc.anonymous=true
rpc_enabled=rpc:option(Flag, "rpc_enabled", translate("RPC enabled"))
rpc_enabled.enabled="true"
rpc_enabled.disabled="false"
rpc_port=rpc:option(Value, "rpc_port", translate("RPC port"))
rpc_port:depends("rpc_enabled", "true")
rpc_bind_address=rpc:option(Value, "rpc_bind_address", translate("RPC bind address"))
rpc_bind_address:depends("rpc_enabled", "true")
rpc_url=rpc:option(Value, "rpc_url", translate("RPC URL"))
rpc_url:depends("rpc_enabled", "true")
rpc_whitelist_enabled=rpc:option(Flag, "rpc_whitelist_enabled", translate("RPC whitelist enabled"))
rpc_whitelist_enabled.enabled="true"
rpc_whitelist_enabled.disabled="false"
rpc_whitelist_enabled:depends("rpc_enabled", "true")
rpc_whitelist=rpc:option(Value, "rpc_whitelist", translate("RPC whitelist"))
rpc_whitelist:depends("rpc_whitelist_enabled", "true")
rpc_authentication_required=rpc:option(Flag, "rpc_authentication_required", translate("RPC authentication required"))
rpc_authentication_required.enabled="true"
rpc_authentication_required.disabled="false"
rpc_authentication_required:depends("rpc_enabled", "true")
rpc_username=rpc:option(Value, "rpc_username", translate("RPC username"))
rpc_username:depends("rpc_authentication_required", "true")
rpc_password=rpc:option(Value, "rpc_password", translate("RPC password"))
rpc_password:depends("rpc_authentication_required", "true")
rpc_password.password = true

return m
