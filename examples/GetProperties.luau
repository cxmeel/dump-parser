--!strict
local DumpParser = require(path.to.DumpParser)

local APIDump = { ... } -- This is a table of all the API dump data

local Dump = DumpParser.new(APIDump)

local Baseplate = workspace:WaitForChild("Baseplate")
local BaseplateMeta = Dump(Baseplate)

-- Print out all properties attached to Baseplate
for _, property in BaseplateMeta.Properties do
	print(property, Baseplate[property])
end

-- Print out all modified properties attached to Baseplate
for _, property in Dump:GetChangedProperties(Baseplate) do
	print(property, Baseplate[property])
end

-- Get the type of the "Anchored" property
print(BaseplateMeta.Properties.Anchored.ValueType) -- { Category = "Primitive", Name = "bool" }
