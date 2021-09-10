-- Copyright 2012 Gabor Varga <vargagab@gmail.com>
-- Licensed to the public under the Apache License 2.0.

require("luci.sys")
require("luci.util")

m = Map("transmission")
m.apply_on_parse=true
function m.on_apply(self)
luci.sys.call("/etc/init.d/transmission restart> /dev/null 2>&1")
end
bandwidth=m:section(NamedSection, "bandwidth", "transmission", translate("Bandwidth settings"))
bandwidth.anonymous=true
alt_speed_enabled=bandwidth:option(Flag, "alt_speed_enabled", translate("Alternative speed enabled"))
alt_speed_enabled.enabled="true"
alt_speed_enabled.disabled="false"
alt_speed_down=bandwidth:option(Value, "alt_speed_down", translate("Alternative download speed"), "KB/s")
alt_speed_down:depends("alt_speed_enabled", "true")
alt_speed_up=bandwidth:option(Value, "alt_speed_up", translate("Alternative upload speed"), "KB/s")
alt_speed_up:depends("alt_speed_enabled", "true")
speed_limit_down_enabled=bandwidth:option(Flag, "speed_limit_down_enabled", translate("Speed limit down enabled"))
speed_limit_down_enabled.enabled="true"
speed_limit_down_enabled.disabled="false"
speed_limit_down=bandwidth:option(Value, "speed_limit_down", translate("Speed limit down"), "KB/s")
speed_limit_down:depends("speed_limit_down_enabled", "true")
speed_limit_up_enabled=bandwidth:option(Flag, "speed_limit_up_enabled", translate("Speed limit up enabled"))
speed_limit_up_enabled.enabled="true"
speed_limit_up_enabled.disabled="false"
speed_limit_up=bandwidth:option(Value, "speed_limit_up", translate("Speed limit up"), "KB/s")
speed_limit_up:depends("speed_limit_up_enabled", "true")
upload_slots_per_torrent=bandwidth:option(Value, "upload_slots_per_torrent", translate("Upload slots per torrent"))

queueing=m:section(NamedSection, "queueing", "transmission", translate("Queueing"))
queueing.anonymous=true
download_queue_enabled=queueing:option(Flag, "download_queue_enabled", translate("Download queue enabled"))
download_queue_enabled.enabled="true"
download_queue_enabled.disabled="false"
download_queue_size=queueing:option(Value, "download_queue_size", translate("Download queue size"))
download_queue_size:depends("download_queue_enabled", "true")
queue_stalled_enabled=queueing:option(Flag, "queue_stalled_enabled", translate("Queue stalled enabled"))
queue_stalled_enabled.enabled="true"
queue_stalled_enabled.disabled="false"
queue_stalled_minutes=queueing:option(Value, "queue_stalled_minutes", translate("Queue stalled minutes"))
queue_stalled_minutes:depends("queue_stalled_enabled", "true")
seed_queue_enabled=queueing:option(Flag, "seed_queue_enabled", translate("Seed queue enabled"))
seed_queue_enabled.enabled="true"
seed_queue_enabled.disabled="false"
seed_queue_size=queueing:option(Value, "seed_queue_size", translate("Seed queue size"))
seed_queue_size:depends("seed_queue_enabled", "true")
scrape_paused_torrents_enabled=queueing:option(Flag, "scrape_paused_torrents_enabled", translate("Scrape paused torrents enabled"))
scrape_paused_torrents_enabled.enabled="true"
scrape_paused_torrents_enabled.disabled="false"

return m
