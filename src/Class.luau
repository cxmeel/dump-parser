--!strict
--[=[
	@class Class
]=]
local T = require(script.Parent["init.d"])

local ClassMemberIndex = require(script.Parent.ClassMemberIndex)

--[=[
	@function new
	@within Class
	@private
	@param ancestry { APIClass }
	@return ClassInstance
]=]
local function Class(ancestry: T.Array<T.APIClass>)
	--[=[
		@interface ClassInstance
		@within Class
		.Name string
		.MemoryCategory string
		.Superclass string
		.Tags { string }?
		.Ancestry { string }
		.Properties ClassMemberIndex
		.Functions ClassMemberIndex
		.Events ClassMemberIndex
		.Callbacks ClassMemberIndex
	]=]
	local self = {}
	local finalDescendant = ancestry[#ancestry]

	self.Name = finalDescendant.Name
	self.MemoryCategory = finalDescendant.MemoryCategory
	self.Superclass = finalDescendant.Superclass
	self.Tags = finalDescendant.Tags
	self.Ancestry = {}

	self.Properties = ClassMemberIndex.new(ancestry, "Property")
	self.Functions = ClassMemberIndex.new(ancestry, "Function")
	self.Events = ClassMemberIndex.new(ancestry, "Event")
	self.Callbacks = ClassMemberIndex.new(ancestry, "Callback")

	for _, class in ancestry do
		table.insert(self.Ancestry, 1, class.Name)
	end

	return self
end

--[=[
	@function findClassEntry
	@within Class
	@private
	@param dump table
	@param className string
	@return APIClass

	Searches the dump for a class entry with the given name.
]=]
local function findClassEntry(dump: T.APIDump, className: string): T.APIClass
	for _, entry in dump.Classes do
		if entry.Name == className then
			return entry
		end
	end

	error(("Unknown class %q"):format(className))
end

--[=[
	@function getClassAncestry
	@within Class
	@private
	@param dump table
	@param className string
	@return { APIClass }

	Returns the ancestry of the class with the given name.
]=]
local function getClassAncestry(dump: T.APIDump, className: string): T.Array<T.APIClass>
	local ancestry = { findClassEntry(dump, className) }
	local nextAncestorClass = ancestry[1].Superclass

	while nextAncestorClass and nextAncestorClass ~= "<<<ROOT>>>" do
		local ancestor = findClassEntry(dump, nextAncestorClass)

		table.insert(ancestry, 1, ancestor)

		nextAncestorClass = ancestor.Superclass
	end

	return ancestry
end

return {
	new = Class,
	findClassEntry = findClassEntry,
	getClassAncestry = getClassAncestry,
}
