--!strict
--[=[
	@class ClassMemberIndex

	A ClassMemberIndexInstance is an array of APIMember.Name strings; however,
	it also uses metatable magic to allow for indexing by APIMember.Name to
	access the full APIMember object, and can also be called directly to
	apply a filter function to the members.

	```lua
	local class = Dump(workspace.Baseplate) -- or Dump("Part")

	print(class.Properties) -- { "Name", "ClassName", "Archivable", ... }
	print(class.Properties.Anchored) -- { Name = "Anchored", ValueType = { ... } }

	print(class.Properties(function()
		return member.Name:sub(1, 1) == "A"
	end)) -- {{ Name = "Archivable", ValueType = { ... }, ... }, { Name = "Anchored", ... }}
	```
]=]
local T = require(script.Parent["init.d"])

--[=[
	@function new
	@within ClassMemberIndex
	@private
	@param ancestry { APIClass }
	@param memberType string
	@return ClassMemberIndexInstance
]=]
local function ClassMemberIndex(ancestry: T.Array<T.APIClass>, memberType: string)
	local memberNameList, memberList = {}, {}
	local metatable = {}

	for _, class in ancestry do
		for _, member in class.Members do
			if member.MemberType == memberType then
				table.insert(memberNameList, member.Name)
				memberList[member.Name] = member
			end
		end
	end

	function metatable:__index(key: string)
		return memberList[key]
	end

	function metatable:__call(predicate: (member: T.APIMember) -> any?): T.Array<T.APIMember>
		local results = {}

		for _, member in memberList do
			if predicate(member) then
				table.insert(results, member)
			end
		end

		return results
	end

	return setmetatable(memberNameList, metatable)
end

return {
	new = ClassMemberIndex,
}
