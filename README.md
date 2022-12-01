# Dump Parser

A generic parser for the Roblox API dump.

## Outline

```lua
type APIDump = { [string]: any }
type Filter<T> = (object: T) -> any

type Class = {}
type Property = {}
type Function = {}
type Callback = {}
type Member = Class | Property | Function | Callback

Dump.new(dump: APIDump)
Dump.fetchDump(hash: string?): APIDump

Dump.Filter: {
  NonDeprecated: (object: Member) -> boolean,
  NonHidden: (object: Member) -> boolean,
  Scriptable: (object: Member) -> boolean,
  Service: (object: Member) -> boolean,
  ...
}

Dump:GetProperties(class: string | Instance): Property
Dump:GetChangedProperties(instance: Instance) { Property }

Dump:GetClass(string | Instance): Class
Dump:GetClasses(...string | Instance | ClassFilter): { [string]: Class }

Class:GetProperty(string): Property
Class:GetProperties(...string | userdata | Filter<Property>): { [string]: Property }

Class:GetEvent(string): Event
Class:GetEvents(...string | Filter<Event>): { [string]: Event }

Class:GetFunction(string): Function
Class:GetFunctions(...string | Filter<Function>): { [string]: Function }

Class:GetCallback(string): Callback
Class:GetCallbacks(...string | Filter<Callback): { [string]: Callback }
```
