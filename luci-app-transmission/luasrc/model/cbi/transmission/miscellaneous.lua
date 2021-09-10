require("luci.sys")
require("luci.util")

m = Map("transmission")
m.apply_on_parse=true
function m.on_apply(self)
luci.sys.call("/etc/init.d/transmission restart> /dev/null 2>&1")
end
misc=m:section(NamedSection,"miscellaneous", "transmission", translate("Miscellaneous"))
misc.anonymous=true
dht_enabled=misc:option(Flag, "dht_enabled", translate("DHT enabled"))
dht_enabled.enabled="true"
dht_enabled.disabled="false"
encryption=misc:option(ListValue, "encryption", translate("Encryption"))
encryption:value("0", translate("Off"))
encryption:value("1", translate("Preferred"))
encryption:value("2", translate("Forced"))
lazy_bitfield_enabled=misc:option(Flag, "lazy_bitfield_enabled", translate("Lazy bitfield enabled"))
lazy_bitfield_enabled.enabled="true"
lazy_bitfield_enabled.disabled="false"
lpd_enabled=misc:option(Flag, "lpd_enabled", translate("LPD enabled"))
lpd_enabled.enabled="true"
lpd_enabled.disabled="false"
message_level=misc:option(ListValue, "message_level", translate("Message level"))
message_level:value("0", translate("None"))
message_level:value("1", translate("Error"))
message_level:value("2", translate("Info"))
message_level:value("3", translate("Debug"))
pex_enabled=misc:option(Flag, "pex_enabled", translate("PEX enabled"))
pex_enabled.enabled="true"
pex_enabled.disabled="false"
script_torrent_done_enabled=misc:option(Flag, "script_torrent_done_enabled", translate("Script torrent done enabled"))
script_torrent_done_enabled.enabled="true"
script_torrent_done_enabled.disabled="false"
script_torrent_done_filename=misc:option(Value, "script_torrent_done_filename", translate("Script torrent done filename"))
script_torrent_done_filename:depends("script_torrent_done_enabled", "true")
idle_seeding_limit_enabled=misc:option(Flag, "idle_seeding_limit_enabled", translate("Idle seeding limit enabled"))
idle_seeding_limit_enabled.enabled="true"
idle_seeding_limit_enabled.disabled="false"
idle_seeding_limit=misc:option(Value, "idle_seeding_limit", translate("Idle seeding limit"))
idle_seeding_limit:depends("idle_seeding_limit_enabled", "true")
utp_enabled=misc:option(Flag, "utp_enabled", translate("uTP enabled"))
utp_enabled.enabled="true"
utp_enabled.disabled="false"

blocklists=m:section(NamedSection, "blocklists", "transmission", translate("Blocklists"))
blocklists.anonymous=true
blocklist_enabled=blocklists:option(Flag, "blocklist_enabled", translate("Block list enabled"))
blocklist_enabled.enabled="true"
blocklist_enabled.disabled="false"
blocklist_url=blocklists:option(Value, "blocklist_url", translate("Blocklist URL"))
blocklist_url:depends("blocklist_enabled", "true")

return m