# Dump Parser

A generic parser for the Roblox API dump.

## Outline

```lua
Dump:GetProperties(class: string | Instance): { [string]: Property }
Dump:GetChangedProperties(instance: Instance) { [string]: Property }

Dump:GetClass(string | Instance): Class
Dump:GetClasses(...string | Instance | Filter<Class>): { [string]: Class }

Class:GetProperty(string): Property
Class:GetProperties(...string | userdata | Filter<Property>): { [string]: Property }

Class:GetEvent(string): Event
Class:GetEvents(...string | Filter<Event>): { [string]: Event }

Class:GetFunction(string): Function
Class:GetFunctions(...string | Filter<Function>): { [string]: Function }

Class:GetCallback(string): Callback
Class:GetCallbacks(...string | Filter<Callback): { [string]: Callback }
```
