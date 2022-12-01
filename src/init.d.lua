--!strict
export type Filter<T> = (object: T) -> any?

export type APIProperty = {
	MemberType: "Property",
	Category: string,
	Name: string,
	Security: {
		Read: string,
		Write: string,
	},
	Serialization: {
		CanLoad: boolean,
		CanSave: boolean,
	},
	Tags: { string }?,
	ThreadSafety: string,
	ValueType: {
		Category: string,
		Name: string,
	},
}

export type APIFunction = {
	MemberType: "Function",
	Name: string,
	Parameters: { { Name: string, Type: string, Default: string? } },
	ReturnType: { Category: string, Name: string },
	Security: string,
	Tags: { string }?,
	ThreadSafety: string,
}

export type APIEvent = {
	MemberType: "Event",
	Name: string,
	Parameters: { { Name: string, Type: string } },
	Security: string,
	Tags: { string }?,
	ThreadSafety: string,
}

export type APICallback = {
	MemberType: "Callback",
	Name: string,
	Parameters: { { Name: string, Type: string } },
	ReturnType: { Category: string, Name: string },
	Security: string,
	Tags: { string }?,
	ThreadSafety: string,
}

export type APIMember = APIProperty | APIFunction | APIEvent | APICallback

export type APIClass = {
	Members: { APIMember },
	MemoryCategory: string,
	Name: string,
	Superclass: string,
	Tags: { string }?,
}

export type APIDump = {
	Classes: { APIClass },
}
