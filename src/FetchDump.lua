--!strict
local HttpService = game:GetService("HttpService")

local T = require(script.Parent["init.d"])

local URL_DEPLOY_HISTORY = "https://s3.amazonaws.com/setup.roblox.com/DeployHistory.txt"
local URL_VERSION_DUMP = "https://s3.amazonaws.com/setup.roblox.com/version-%s-API-Dump.json"
local URL_CURRENT_VERSION = "https://s3.amazonaws.com/setup.roblox.com/versionQTStudio"

-- selene: allow(undefined_variable)
local RobloxVersion = version()

local function HttpRequest<T>(url: string, json: boolean?): T
	local response = HttpService:RequestAsync({
		Url = url,
	})

	if json then
		return HttpService:JSONDecode(response.Body)
	end

	return response.Body
end

local function FetchLatestVersionHash(): string
	local versionHash: string = HttpRequest(URL_CURRENT_VERSION)
	local hash = versionHash:match("version%-(%x+)")

	return hash
end

local function FetchVersionHash(version: string?): string
	version = version or RobloxVersion

	local deployHistory: string = HttpRequest(URL_DEPLOY_HISTORY)
	local deployments = deployHistory:split("\n")
	local versionHash: string = nil

	for lineNumber = #deployments, 1, -1 do
		local line = deployments[lineNumber]

		if line:find(version) then
			versionHash = line:match("version%-(%x+)")
			break
		end

		if lineNumber >= 128 then
			error("Could not find version hash for version " .. version)
		end
	end

	return versionHash
end

local function FetchVersionHashWithFallback(version: string): string
	local ok, versionHash = pcall(FetchVersionHash, version)

	if not ok then
		versionHash = FetchLatestVersionHash()
	end

	return versionHash
end

local function FetchDump(hash: string?): T.APIDump
	local apiDump = HttpRequest(URL_VERSION_DUMP:format(hash), true)

	return apiDump
end

return {
	fetchDump = FetchDump,
	fetchLatestVersionHash = FetchLatestVersionHash,
	fetchVersionHash = FetchVersionHash,
	fetchVersionHashWithFallback = FetchVersionHashWithFallback,
}
