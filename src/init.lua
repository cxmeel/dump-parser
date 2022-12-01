--!strict
local T = require(script["init.d"])
local FetchDump = require(script.FetchDump)

local Dump = {}

Dump.__index = Dump

function Dump.new(dump: T.APIDump)
	local self = setmetatable({}, Dump)

	self._dump = dump

	return self
end

function Dump.fetchDump(hashOrVersion: string?): T.APIDump
	local isVersionString = hashOrVersion:match("%d+%.") ~= nil

	if isVersionString then
		hashOrVersion = FetchDump.fetchVersionHashWithFallback(hashOrVersion)
	end

	return FetchDump.fetchDump(hashOrVersion)
end

function Dump.fromServer(hashOrVersion: string?)
	local apiDump = Dump.fetchDump(hashOrVersion)
	local dump = Dump.new(apiDump)

	return dump
end

return Dump
