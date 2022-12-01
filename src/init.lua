--!strict
--[=[
	@class Dump

	An easy to use and functional interface for processing and
	accessing Roblox API dump data.
]=]
local T = require(script["init.d"])

local FetchDump = require(script.FetchDump)
local Array = require(script.Util.Array)
local Filter = require(script.Filter)
local Class = require(script.Class)

local Dump = {}

Dump.__index = Dump

local ERR_DUMP_INVALID = 'Invalid API dump; expected table, got "%*" (%s)'
local ERR_DUMP_CLASSES_INVALID =
	'Invalid field "Classes" in API dump; expected table, got "%*" (%s)'
local ERR_CLASS_ARG_INVALID = 'Invalid argument "class"; expected string, got "%*" (%s)'
local ERR_UNKNOWN_CLASSNAME = "Could not find class in dump with name %q"

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
		error(ERR_DUMP_INVALID:format(dump, typeof(dump)))
	end

	if typeof(dump.Classes) ~= "table" then
		error(ERR_DUMP_CLASSES_INVALID:format(dump.Classes, typeof(dump.Classes)))
	end

	local self = setmetatable({}, Dump)

	self._dump = dump

	return self
end

--[=[
	@function fetchRawDump
	@within Dump
	@param hashOrVersion string?
	@return APIDump

	Fetches the API dump for the current version of Roblox from the
	Roblox API. If a hash or version is provided, it will attempt to
	fetch the dump for that hash or version.
]=]
function Dump.fetchRawDump(hashOrVersion: string?): T.APIDump
	local isVersionString = hashOrVersion and hashOrVersion:match("%d+%.") ~= nil

	if isVersionString then
		hashOrVersion = FetchDump.fetchVersionHashWithFallback(hashOrVersion)
	end

	return FetchDump.fetchDump(hashOrVersion)
end

--[=[
	@function fetchFromServer
	@within Dump
	@param hashOrVersion string?
	@return Dump

	Performs the same actions as [`fetchDump`][Dump.fetchDump], but returns a
	[Dump] instance instead of the raw API data.
]=]
function Dump.fetchFromServer(hashOrVersion: string?)
	local apiDump = Dump.fetchRawDump(hashOrVersion)
	local dump = Dump.new(apiDump)

	return dump
end

--[=[
	@method findRawClassEntry
	@within Dump
	@private
	@param className string
	@return Class

	An internal method that finds the class entry for the given
	class name. If the class entry cannot be found, it will throw
	an error.
]=]
function Dump:findRawClassEntry(className: string): T.Class
	for _, class: T.Class in self._dump.Classes do
		if class.Name == className then
			return class
		end
	end

	error(ERR_UNKNOWN_CLASSNAME:format(className))
end

--[=[
	@method constructRawClass
	@within Dump
	@private
	@param class Class
	@return Class

	An internal method that constructs a table of raw class data from
	the given class object, merging in all the class ancestors' members.
]=]
function Dump:constructRawClass(class: T.Class): T.Class
	local finalDescendant = class

	local memberAncestry = finalDescendant.Members
	local nextAncestorClassName = finalDescendant.Superclass

	while nextAncestorClassName and nextAncestorClassName ~= "<<<ROOT>>>" do
		local ancestor = self:findRawClassEntry(nextAncestorClassName)

		for _, member in ancestor.Members do
			table.insert(memberAncestry, member)
		end

		nextAncestorClassName = ancestor.Superclass
	end

	local constructed: T.Class = {}

	constructed.Members = memberAncestry
	constructed.MemoryCategory = finalDescendant.MemoryCategory
	constructed.Name = finalDescendant.Name
	constructed.Superclass = finalDescendant.Superclass
	constructed.Tags = finalDescendant.Tags

	return constructed
end

--[=[
	@method filterClasses
	@within Dump
	@private
	@param filters { string | GenericFilter<Class> | Instance }
	@return { [string]: Class }

	Accepts a table of filters and returns a table of classes that
	match the given filters. The keys of the returned table are the
	class names, and the values are the class entries.
]=]
function Dump:filterClasses(filters: { string | T.GenericFilter<T.Class> | Instance })
	local filteredResults: { T.Class } = self._dump.Classes

	if #filters > 0 then
		filters = Array.map(filters, function(filter)
			local filterType = typeof(filter)

			if filterType == "function" then
				return filter
			elseif filterType == "string" then
				return Filter.Name(filter)
			elseif filterType == "Instance" then
				return Filter.Name(filter.ClassName)
			end

			error("Invalid filter type: " .. filterType)
		end)

		for _, filter in filters do
			filteredResults = Array.filter(filteredResults, filter)
		end
	end

	local results = {}

	for _, class in filteredResults do
		results[class.Name] = Class.new(self:constructRawClass(class))
	end

	return results
end

--[=[
	@method GetClasses
	@within Dump
	@param ... (string | Instance | GenericFilter<Class>)?
	@return { [string]: Class }

	Gets all the classes from the API dump. If any arguments are
	passed, it will filter the classes based on the given arguments.
]=]
function Dump:GetClasses(...: (string | Instance | T.GenericFilter<T.Class>)?)
	return self:filterClasses({ ... })
end

--[=[
	@method GetClass
	@within Dump
	@param class string | Instance
	@return Class

	Gets the class with the given name from the API dump. If the
	class is not found, it will throw an error. If an instance is
	passed, it will determine the class name from `Instance.ClassName`.
]=]
function Dump:GetClass(class: string | Instance)
	local className = typeof(class) == "Instance" and class.ClassName or class

	if typeof(className) ~= "string" then
		error(ERR_CLASS_ARG_INVALID:format(className, typeof(className)))
	end

	return self:GetClasses(className)[className]
end

--[=[
	@method GetProperties
	@within Dump
	@param class string | Instance
	@return { [string]: Property }

	Gets a list of properties for the given class. If an Instance
	is passed, it will determine the class from `Instance.ClassName`.
]=]
function Dump:GetProperties(class: string | Instance, ...: (string | T.GenericFilter<T.Property>)?)
	local classInstance = self:GetClass(class)

	return classInstance:GetProperties(Filter.Invert(Filter.Deprecated), Filter.HasSecurity("None"), ...)
end

--[=[
  @method GetChangedProperties
	@within Dump
	@param instance Instance
	@return { [string]: Property }

	Gets a list of properties that have been changed from the
	default value for the given instance.
]=]
function Dump:GetChangedProperties(instance: Instance)
	local properties = self:GetProperties(instance)
  local changedProperties = {}

	return changedProperties
end

return Dump
