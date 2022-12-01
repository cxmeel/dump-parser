--!strict
--[=[
	@class Filter

	A list of various filters that can be used to filter out API
	members from the dump. This is useful for filtering members, such
	as those that are deprecated or inaccessible to non-CoreScripts.
]=]
local T = require(script.Parent["init.d"])

--[=[
	@interface SecurityLevels
	@within Filter
	.Read (string | { string })?
	.Write (string | { string })?
]=]
type SecurityLevels = {
	Read: (string | { string })?,
	Write: (string | { string })?,
}

--[=[
	@prop HasTags (...: string) -> GenericFilter<Item>
	@within Filter

	Checks if the given [Item] has any of the given tags. If multiple
	tags are given, then the [Item] must have all of the tags in order
	to pass the filter.
]=]
local function HasTags(...: string): T.GenericFilter<T.Item>
	local tags = { ... }

	return function(object: T.Item)
		if object.Tags == nil then
			return false
		end

		local matchCount = 0

		for _, tag in tags do
			if table.find(object.Tags, tag) ~= nil then
				matchCount += 1
			end
		end

		return matchCount == #tags
	end
end

--[=[
	@prop HasSecurity (levels: SecurityLevels | string) -> GenericFilter<Item>
	@within Filter

	Accepts a [SecurityLevels] object or a string. If a string is passed,
	both Read and Write will be set to that string. [SecurityLevels] can
	also accept an array of strings for Read and Write, which will be
	used as an `OR` condition, meaning that the object will be accepted
	if it matches any of the strings in the array.

	This filter *can* also be used on [Items] whose `Security` field is
	a string, such as [Function]s.
]=]
local function HasSecurity(levels: SecurityLevels | string): T.GenericFilter<T.Item>
	if type(levels) == "string" then
		levels = { Read = levels, Write = levels }
	end

	return function(object: T.Item)
		if object.Security == nil then
			return false
		end

		if typeof(object.Security) == "string" then
			return levels.Read == object.Security or levels.Write == object.Security
		end

		local read = typeof(levels.Read) == "string" and { levels.Read } or levels.Read
		local write = typeof(levels.Write) == "string" and { levels.Write } or levels.Write

		return table.find(read, object.Security.Read) ~= nil
			and table.find(write, object.Security.Write) ~= nil
	end
end

--[=[
	@prop Invert (filter: GenericFilter<Item>) -> GenericFilter<Item>
	@within Filter

	Inverts the given filter. If the filter returns `true`, then this
	filter will return `false`, and vice versa. For example:

	```lua
	local NonDeprecated = Filter.Invert(Filter.Deprecated)
	```
]=]
local function Invert(filter: T.GenericFilter<T.Item>): T.GenericFilter<T.Item>
	return function(...)
		return not filter(...)
	end
end

--[=[
	@prop Deprecated GenericFilter<Item>
	@within Filter
]=]
local Deprecated: T.GenericFilter<T.Item> = function(object)
	return HasTags("Deprecated")(object)
end

--[=[
	@prop ReadOnly GenericFilter<Item>
	@within Filter
]=]
local ReadOnly: T.GenericFilter<T.Item> = function(object)
	return HasTags("ReadOnly")(object)
end

--[=[
	@prop Replicated GenericFilter<Item>
	@within Filter
]=]
local Replicated: T.GenericFilter<T.Item> = Invert(HasTags("NotReplicated"))

--[=[
	@prop Scriptable GenericFilter<Item>
	@within Filter
]=]
local Scriptable: T.GenericFilter<T.Item> = Invert(HasTags("NotScriptable"))

--[=[
	@prop Yields GenericFilter<Item>
	@within Filter
]=]
local Yields: T.GenericFilter<T.Item> = function(object)
	return HasTags("Yields")(object)
end

--[=[
	@prop ThreadSafe GenericFilter<Item>
	@within Filter
]=]
local ThreadSafe: T.GenericFilter<T.Item> = function(object)
	return object.ThreadSafety == "ThreadSafe"
end

--[=[
	@prop Readable GenericFilter<Item>
	@within Filter
]=]
local Readable: T.GenericFilter<T.Item> = function(object)
	return HasSecurity({ Read = "None" })(object)
end

--[=[
	@prop Writable GenericFilter<Item>
	@within Filter
]=]
local Writable: T.GenericFilter<T.Item> = function(object)
	return HasSecurity({ Write = "None" })(object)
end

--[=[
	@prop Service GenericFilter<Item>
	@within Filter
]=]
local Service: T.GenericFilter<T.Item> = function(object)
	return object.Tags ~= nil and table.find(object.Tags, "Service") ~= nil
end

return {
	Deprecated = Deprecated,
	HasSecurity = HasSecurity,
	HasTags = HasTags,
	Invert = Invert,
	Readable = Readable,
	ReadOnly = ReadOnly,
	Replicated = Replicated,
	Scriptable = Scriptable,
	Service = Service,
	ThreadSafe = ThreadSafe,
	Writable = Writable,
	Yields = Yields,
}
