# Dump Parser

A generic parser for the Roblox API dump. Inspired by [@corecii](https://github.com/Corecii)'s
[API Dump (Static)](https://github.com/corecii/api-dump-static) and
[@raphtalia](https://github.com/raphtalia)'s [RobloxAPI](https://github.com/raphtalia/robloxapi)
libraries.

## Documentation

Documentation can be found at https://csqrl.github.io/dump-parser.

## Quick Start

Dump Parser is available via [Wally](https://wally.run).

### Wally

```toml
# wally.toml

[dependencies]
DumpParser = "csqrl/dump-parser@0.1.0"
```

```bash
$ wally install
```

### Manual Installation

Download a copy of the latest release from the GitHub repo,
and compile it using Rojo. From there, you can drop the
binary directly into your project files or Roblox Studio.

## Example Usage

~~~lua
local DumpParser = require(path.to.DumpParser)
local Dump = DumpParser.fetchFromServer()

local PartClass = Dump:GetClass("Part")

-- Get a list of all properties on "Part"
print(PartClass:GetProperties())

--[[
	Get a list of safe-to-use properties on "Part". This is
	functionally equivalent to:

	```lua
	PartClass:GetProperties(
		Filter.Invert(Filter.Deprecated),
		Filter.HasSecurity("None"),
		Filter.Scriptable,
	)
	```

	`GetProperties`, `GetEvents`, `GetFunctions` and `GetCallbacks`
	all accept a variable number of filters as arguments. This
	allows you to filter down the list of results to only what
	you need.
--]]
print(Dump:GetProperties("Part"))
~~~
