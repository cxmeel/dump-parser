--!strict
--[=[
	@class Dump
]=]
local T = require(script["init.d"])

local Class = require(script.Class)

local Dump = {}

Dump.__index = Dump

local ERR_INVALID_DUMP = 'Invalid API dump; expected a table, got "%*" (%s)'
local ERR_INVALID_CLASSNAME = 'Invalid class name; expected a string, got "%*" (%s)'

local RECORDED_PROPERTIES = {}
local NONE = newproxy(false)

local IGNORED_TAG_LIST = {
	"NotCreatable",
	"NotBrowsable",
	"ReadOnly",
	"Hidden",
	"Deprecated",
	"NotScriptable",
}

--[=[
	@function new
	@within Dump
	@param dump table
	@return Dump

	Creates a new Dump instance from the given API dump.
]=]
function Dump.new(dump: T.APIDump)
	if typeof(dump) ~= "table" or typeof(dump.Classes) ~= "table" then
		error(ERR_INVALID_DUMP:format(dump, typeof(dump)), 2)
	end

	local self = setmetatable({}, Dump)

	self._dump = dump

	return self
end

--[=[
	@method GetClass
	@within Dump
	@param class string | Instance
	@return ClassInstance

	Returns the class with the given name. This method can also be
	called using `Dump(class)`.

	```lua
	local dump = DumpParser.new(APIDump)

	local class = dump:GetClass("Instance")
	local class = dump:GetClass(workspace.Baseplate)
	local class = dump("Instance")
	local class = dump(workspace.Baseplate)
	```
]=]
function Dump:GetClass(class: string | Instance)
	local className = typeof(class) == "Instance" and class.ClassName or class

	if typeof(className) ~= "string" then
		error(ERR_INVALID_CLASSNAME:format(className, typeof(className)), 2)
	end

	local ancestry = Class.getClassAncestry(self._dump, className)
	local newClass = Class.new(ancestry)

	return newClass
end

--[=[
	@method GetSafeProperties
	@within Dump
	@param class string | Instance
	@return { string }

	Returns a list of properties that are safe to read and write from
	scripts with normal permissions.
]=]
function Dump:GetSafeProperties(class: string | Instance): T.Array<string>
	local className = typeof(class) == "Instance" and class.ClassName or class

	if typeof(className) ~= "string" then
		error(ERR_INVALID_CLASSNAME:format(className, typeof(className)), 2)
	end

	local safeProperties = {}

	local filteredProperties = self:GetClass(className).Properties(function(member: T.APIMember)
		if member.Security.Read ~= "None" or member.Security.Write ~= "None" then
			return false
		end

		if member.Tags then
			for _, tag in member.Tags do
				if table.find(IGNORED_TAG_LIST, tag) then
					return false
				end
			end
		end

		return true
	end)

	for _, property in filteredProperties do
		table.insert(safeProperties, property.Name)
	end

	table.sort(safeProperties)

	return safeProperties
end

--[=[
	@method GetChangedProperties
	@within Dump
	@param instance Instance
	@return { string }

	Returns a list of (safe) properties that have been changed from their
	default values.
]=]
function Dump:GetChangedProperties(instance: Instance): T.Array<string>
	local propertyList = self:GetSafeProperties(instance)

	local changedProperties = {}
	local untestedProperties = {}

	for _, property in propertyList do
		local defaultValue = RECORDED_PROPERTIES[property.Name]

		if defaultValue == nil then
			table.insert(untestedProperties, property.Name)
			continue
		end

		if defaultValue == NONE then
			defaultValue = nil
		end

		if instance[property.Name] ~= defaultValue then
			table.insert(changedProperties, property.Name)
		end
	end

	if #untestedProperties > 0 then
		local testInstance = Instance.new(instance.ClassName)

		for _, property in untestedProperties do
			local defaultValue = testInstance[property]

			if defaultValue ~= instance[property] then
				table.insert(changedProperties, property)
			end

			RECORDED_PROPERTIES[property] = defaultValue or NONE
		end

		testInstance:Destroy()
	end

	table.sort(changedProperties)

	return changedProperties
end

Dump.__call = Dump.GetClass

return Dump
