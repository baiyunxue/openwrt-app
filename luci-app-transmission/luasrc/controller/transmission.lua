-- Copyright 2012 Gabor Varga <vargagab@gmail.com>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.transmission", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/transmission") then
		return
	end
	
	entry({"admin", "services", "transmission"},alias("admin", "services", "transmission", "general"),_("Transmission"),10)
	entry({"admin", "services", "transmission", "general"},cbi("transmission/general"),_("General Settings"), 10).leaf = true
	entry({"admin", "services", "transmission", "fileslocations"},cbi("transmission/fileslocations"),_("Files and Locations"), 11).leaf = true
	entry({"admin", "services", "transmission", "bandwidth"},cbi("transmission/bandwidth"),_("Bandwidth settings"), 12).leaf = true
	entry({"admin", "services", "transmission", "peer"},cbi("transmission/peer"),_("Peer settings"), 13).leaf = true
	entry({"admin", "services", "transmission", "miscellaneous"},cbi("transmission/miscellaneous"),_("Miscellaneous"), 16).leaf = true
	entry({"admin", "services", "transmission", "status"}, call("status")).leaf = true

end

function status()
	local sys  = require "luci.sys"
	local ipkg = require "luci.model.ipkg"
	local http = require "luci.http"

	local status = {
		running = (sys.call("pidof transmission-daemon > /dev/null") == 0),
		transmission_web = ipkg.installed("transmission-web")
	}

	http.prepare_content("application/json")
	http.write_json(status)
end
