--!strict
local HttpService = game:GetService("HttpService")

-- selene: allow(undefined_variable)
local RobloxVersion = version()
local DeploymentVersion = RobloxVersion:gsub("%.", ", ")

local function HttpGet<T>(url: string, json: boolean?): T
	local response = HttpService:RequestAsync({
		Url = url,
	})

	if json == true then
		return HttpService:JSONDecode(response.Body)
	end

	return response.Body
end

local deployHistory: string = HttpGet("https://s3.amazonaws.com/setup.roblox.com/DeployHistory.txt")
local deployments = deployHistory:split("\n")
local versionHash: string = nil

for lineNumber = #deployments, 1, -1 do
	local line = deployments[lineNumber]

	if line:find(DeploymentVersion) then
		versionHash = line:match("version%-(%x+)")
		break
	end

	if lineNumber >= 128 then
		error("Could not find version hash for version " .. RobloxVersion)
	end
end

local apiDump = HttpGet(
	"https://s3.amazonaws.com/setup.roblox.com/version-" .. versionHash .. "-API-Dump.json",
	true
)

return apiDump
