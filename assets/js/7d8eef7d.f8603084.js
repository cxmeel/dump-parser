"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[866],{81595:e=>{e.exports=JSON.parse('{"functions":[{"name":"HasTags","desc":"Checks if the given [Item] has any of the given tags. If multiple\\ntags are given, then the [Item] must have all of the tags in order\\nto pass the filter.","params":[{"name":"...","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"GenericFilter<Item>"}],"function_type":"static","source":{"line":40,"path":"src/Filter.lua"}},{"name":"HasSecurity","desc":"Accepts a [SecurityLevels] object or a string. If a string is passed,\\nboth Read and Write will be set to that string. [SecurityLevels] can\\nalso accept an array of strings for Read and Write, which will be\\nused as an `OR` condition, meaning that the object will be accepted\\nif it matches any of the strings in the array.\\n\\nThis filter *can* also be used on [Items] whose `Security` field is\\na string, such as [Function]s.","params":[{"name":"levels","desc":"","lua_type":"SecurityLevels | string"}],"returns":[{"desc":"","lua_type":"GenericFilter<Item>"}],"function_type":"static","source":{"line":75,"path":"src/Filter.lua"}},{"name":"Invert","desc":"Inverts the given filter. If the filter returns `true`, then this\\nfilter will return `false`, and vice versa. For example:\\n\\n```lua\\nlocal NonDeprecated = Filter.Invert(Filter.Deprecated)\\n```","params":[{"name":"filter","desc":"","lua_type":"GenericFilter<Item>"}],"returns":[{"desc":"","lua_type":"GenericFilter<Item>"}],"function_type":"static","source":{"line":110,"path":"src/Filter.lua"}},{"name":"MemberType","desc":"Checks if the given [Item] is of the given member type; for example,\\nwhen trying to access only members which are of type `\\"Property\\"`.","params":[{"name":"memberType","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"GenericFilter<Item>"}],"function_type":"static","source":{"line":193,"path":"src/Filter.lua"}},{"name":"Name","desc":"Checks if the given [Item]\'s name matches the given string.","params":[{"name":"name","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"GenericFilter<Item>"}],"function_type":"static","source":{"line":207,"path":"src/Filter.lua"}},{"name":"Any","desc":"Combines multiple filters into a single filter. The returned filter\\nwill return `true` if *any* of the given filters return `true`. If\\nno filters are given, then the returned filter will always return\\n`true`, but will print a warning to the output.","params":[{"name":"...","desc":"","lua_type":"GenericFilter<Item>"}],"returns":[{"desc":"","lua_type":"GenericFilter<Item>"}],"function_type":"static","source":{"line":224,"path":"src/Filter.lua"}},{"name":"ValueType","desc":"Returns `true` for any [Item] whose `ValueType` field is of the given type.\\nPrimitive Luau types, such as `string` or `number` can be used; they will\\nautomatically be mapped to the corresponding `ValueType` string (e.g.\\n`number` can refer to `float`, `double`, `int`, etc.).","params":[{"name":"type","desc":"","lua_type":"string | nil"}],"returns":[{"desc":"","lua_type":"GenericFilter<Item>"}],"function_type":"static","source":{"line":257,"path":"src/Filter.lua"}}],"properties":[{"name":"Deprecated","desc":"","lua_type":"GenericFilter<Item>","source":{"line":120,"path":"src/Filter.lua"}},{"name":"ReadOnly","desc":"","lua_type":"GenericFilter<Item>","source":{"line":128,"path":"src/Filter.lua"}},{"name":"Replicated","desc":"","lua_type":"GenericFilter<Item>","source":{"line":136,"path":"src/Filter.lua"}},{"name":"Scriptable","desc":"","lua_type":"GenericFilter<Item>","source":{"line":142,"path":"src/Filter.lua"}},{"name":"Yields","desc":"","lua_type":"GenericFilter<Item>","source":{"line":148,"path":"src/Filter.lua"}},{"name":"ThreadSafe","desc":"","lua_type":"GenericFilter<Item>","source":{"line":156,"path":"src/Filter.lua"}},{"name":"Readable","desc":"","lua_type":"GenericFilter<Item>","source":{"line":164,"path":"src/Filter.lua"}},{"name":"Writable","desc":"","lua_type":"GenericFilter<Item>","source":{"line":172,"path":"src/Filter.lua"}},{"name":"Service","desc":"","lua_type":"GenericFilter<Item>","source":{"line":180,"path":"src/Filter.lua"}}],"types":[{"name":"SecurityLevels","desc":"","fields":[{"name":"Read","lua_type":"(string | { string })?","desc":""},{"name":"Write","lua_type":"(string | { string })?","desc":""}],"source":{"line":25,"path":"src/Filter.lua"}}],"name":"Filter","desc":"A list of various filters that can be used to filter out API\\nmembers from the dump. This is useful for filtering members, such\\nas those that are deprecated or inaccessible to non-CoreScripts.","source":{"line":9,"path":"src/Filter.lua"}}')}}]);