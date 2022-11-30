--!strict
export type Dictionary<K, V> = { [K]: V }
export type Array<T> = Dictionary<number, T>

export type Primitive = string | number | boolean

export type Security =
	"None"
	| "LocalUserSecurity"
	| "PluginSecurity"
	| "RobloxScriptSecurity"
	| "RobloxSecurity"
	| "NotAccessibleSecurity"

export type ThreadSafety = "ReadSafe" | "Unsafe" | "Safe"

export type Tags =
	"NotCreatable"
	| "NotBrowsable"
	| "ReadOnly"
	| "NotReplicated"
	| "Hidden"
	| "Deprecated"
	| "CustomLuaState"
	| "CanYield"
	| "NotScriptable"
	| "Service"
	| "Yields"
	| "PlayerReplicated"
	| "Settings"
	| "NoYield"
	| "UserSettings"

export type APIMember = Dictionary<string, any>

export type APIClass = {
	Members: Array<APIMember>,
	MemoryCategory: string,
	Name: string,
	Superclass: string,
	Tags: Array<Tags>?,
}

export type APIDump = Dictionary<string, any> & {
	Classes: Array<APIClass>,
}

return {}
