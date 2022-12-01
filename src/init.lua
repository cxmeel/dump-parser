--!strict
local Dump = {}

Dump.__index = Dump

function Dump.new(dump)
  local self = setmetatable({}, Dump)

  return self
end

function Dump.fetchDump(hash: string?)
  -- Fetch dump from API
end

function Dump.fromServer(hash: string?)
  local dump = Dump.fetchDump(hash)

  return Dump.new(dump)
end

return Dump
