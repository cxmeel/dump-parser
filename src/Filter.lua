--!strict
local T = require(script.Parent["init.d"])

type Filter<T> = T.Filter<T>
type APIEntry = T.APIClass | T.APIMember

type SecurityLevels = {
        Read: (string | { string })?,
        Write: (string | { string })?,
}

local function HasTags(...: string): Filter<APIEntry>
	local tags = { ... }

	return function(object: APIEntry)
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

local function HasSecurity(levels: SecurityLevels): Filter<APIEntry>
        return function(object: APIEntry)
                if object.Security == nil then
                        return false
                end

                local read = typeof(levels.Read) == "string" and { levels.Read } or levels.Read
                local write = typeof(levels.Write) == "string" and { levels.Write } or levels.Write

                return table.find(read, object.Security.Read) ~= nil
                        and table.find(write, object.Security.Write) ~= nil
        end
end

local function Invert(filter: Filter<APIEntry>): Filter<APIEntry>
	return function(object: APIEntry)
		return not filter(object)
	end
end

local Deprecated: Filter<APIEntry> = function(object)
	return HasTags("Deprecated")(object)
end

local ReadOnly: Filter<APIEntry> = function(object)
	return HasTags("ReadOnly")(object)
end

local Replicated: Filter<APIEntry> = Invert(HasTags("NotReplicated"))

local Scriptable: Filter<APIEntry> = Invert(HasTags("NotScriptable"))

local Yields: Filter<APIEntry> = function(object)
	return HasTags("Yields")(object)
end

local ThreadSafe: Filter<APIEntry> = function(object)
	return object.ThreadSafety == "ThreadSafe"
end

local Readable: Filter<APIEntry> = function(object)
	return HasSecurity({ Read = "None" })(object)
end

local Writable: Filter<APIEntry> = function(object)
	return HasSecurity({ Write = "None" })(object)
end

local Service: Filter<APIEntry> = function(object)
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
