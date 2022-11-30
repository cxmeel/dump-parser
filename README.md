# Dump Parser

A generic parser for the Roblox API dump.

## Usage

```lua
local DumpParser = require(path.to.DumpParser)

-- We don't care how/where you obtain the API dump
local APIDump = { ... }

-- Pass the API dump into a new DumpParser instance
local Dump = DumpParser.new(APIDump)

-- Access information about Instances using the Dump
local basePart = Dump("BasePart") -- Alternatively, pass an Instance: `Dump(workspace.Baseplate)`

-- Access a list of all property names for BasePart
print(basePart.Properties) -- { string }

-- Access metadata about a specific property
print(basePart.Properties.Anchored) -- { [string]: any }

-- Filter properties
local filtered = basePart.Properties(function(property)
 return property.Name:sub(1, 1) == "A" -- Return only properties beginning with "A"
end)

-- Fetch a list of safe-to-use property names for a class
print(Dump:GetSafeProperties("BasePart"))

-- Fetch a list of changed (safe) property names for an Instance
print(Dump:GetChangedProperties(workspace.Baseplate))
```
