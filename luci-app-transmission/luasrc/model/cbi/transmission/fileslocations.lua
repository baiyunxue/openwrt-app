require("luci.sys")
require("luci.util")

m = Map("transmission")
m.apply_on_parse=true
function m.on_apply(self)
luci.sys.call("/etc/init.d/transmission restart> /dev/null 2>&1")
end
fileslocations=m:section(NamedSection, "fileslocations", "transmission", translate("Files and Locations"))
fileslocations.anonymous=true
local devices = {}
nixio.util.consume((nixio.fs.glob("/tmp/mnt/sd?*")), devices)
download_dir=fileslocations:option(Value, "download_dir", translate("Download directory"))
download_dir.rmempty = false
for i, dev in ipairs(devices) do
        download_dir:value(dev.."/transmission/done")
end

incomplete_dir_enabled=fileslocations:option(Flag, "incomplete_dir_enabled", translate("Incomplete directory enabled"))
incomplete_dir_enabled.enabled="true"
incomplete_dir_enabled.disabled="false"

incomplete_dir=fileslocations:option(Value, "incomplete_dir", translate("Incomplete directory"))
incomplete_dir:depends("incomplete_dir_enabled", "true")
preallocation=fileslocations:option(ListValue, "preallocation", translate("preallocation"))
preallocation:value("0", translate("Off"))
preallocation:value("1", translate("Fast"))
preallocation:value("2", translate("Full"))
prefetch_enabled=fileslocations:option(Flag, "prefetch_enabled", translate("Prefetch enabled"))
rename_partial_files=fileslocations:option(Flag, "rename_partial_files", translate("Rename partial files"))
rename_partial_files.enableid="true"
rename_partial_files.disabled="false"
start_added_torrents=fileslocations:option(Flag, "start_added_torrents", translate("Automatically start added torrents"))
start_added_torrents.enabled="true"
start_added_torrents.disabled="false"
trash_original_torrent_files=fileslocations:option(Flag, "trash_original_torrent_files", translate("Trash original torrent files"))
trash_original_torrent_files.enabled="true"
trash_original_torrent_files.disabled="false"
umask=fileslocations:option(Value, "umask", "umask")
watch_dir_enabled=fileslocations:option(Flag, "watch_dir_enabled", translate("Enable watch directory"))
watch_dir_enabled.enabled="true"
watch_dir_enabled.disabled="false"
watch_dir=fileslocations:option(Value, "watch_dir", translate("Watch directory"))
watch_dir:depends("watch_dir_enabled", "true")

return m