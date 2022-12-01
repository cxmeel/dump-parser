--!strict
--[=[
	@class Dump

	An easy to use and functional interface for processing and
	accessing Roblox API dump data.
]=]
local T = require(script["init.d"])

local FetchDump = require(script.FetchDump)
local Filter = require(script.Filter)

local Dump = {}

Dump.__index = Dump

local ERR_DUMP_INVALID = 'Invalid API dump; expected table, got "%*" (%s)'
local ERR_DUMP_CLASSES_INVALID =
	'Invalid field "Classes" in API dump; expected table, got "%*" (%s)'
local ERR_CLASS_ARG_INVALID = 'Invalid argument "class"; expected string, got "%*" (%s)'

--[=[
	@prop Filter Filter
	@within Dump

	A frozen list of various filters that can be used to filter out
	API members from the dump. This is useful for filtering members,
	such as those that are deprecated or inaccessible to
	non-CoreScripts.
]=]
Dump.Filter = table.freeze(Filter)

--[=[
	@function new
	@within Dump
	@param dump APIDump
	@return Dump

	Creates a new Dump instance from the given API dump. We don't
	necessarily care where the dump came from, as long as it's
	properly formatted.
]=]
function Dump.new(dump: T.APIDump)
	if typeof(dump) ~= "table" then
		error(ERR_DUMP_INVALID:format(dump, typeof(dump)), 2)
	end

	if typeof(dump.Classes) ~= "table" then
		error(ERR_DUMP_CLASSES_INVALID:format(dump.Classes, typeof(dump.Classes)), 2)
	end

	local self = setmetatable({}, Dump)

	self._dump = dump

	return self
end

--[=[
	@function fetchDump
	@within Dump
	@param hashOrVersion string?
	@return APIDump

	Fetches the API dump for the current version of Roblox from the
	Roblox API. If a hash or version is provided, it will attempt to
	fetch the dump for that hash or version.
]=]
function Dump.fetchDump(hashOrVersion: string?): T.APIDump
	local isVersionString = hashOrVersion:match("%d+%.") ~= nil

	if isVersionString then
		hashOrVersion = FetchDump.fetchVersionHashWithFallback(hashOrVersion)
	end

	return FetchDump.fetchDump(hashOrVersion)
end

--[=[
	@function fromServer
	@within Dump
	@param hashOrVersion string?
	@return Dump

	Performs the same actions as [`fetchDump`][Dump.fetchDump], but returns a
	[Dump] instance instead of the raw API data.
]=]
function Dump.fromServer(hashOrVersion: string?)
	local apiDump = Dump.fetchDump(hashOrVersion)
	local dump = Dump.new(apiDump)

	return dump
end

--[=[
	@method GetProperties
	@within Dump
	@param class string | Instance
	@return { [string]: Property }

	Gets a list of properties for the given class. If an Instance
	is passed, it will determine the class from `Instance.ClassName`.
]=]
function Dump:GetProperties(class: string | Instance): { [string]: T.Property }
	local className = typeof(class) == "Instance" and class.ClassName or class

	if typeof(className) ~= "string" then
		error(ERR_CLASS_ARG_INVALID:format(className, typeof(className)), 2)
	end
end

return Dump
