-- CONFIG
local API_URL = "http://YP:6842"
local API_SECRET = "48491b998fe7a16954ebe20bb68f195c8ed40d04289bf156dafcbd84a4f5b02f"
local GUILD_ID = "1451295256611127378"


local Key = getgenv().Key
if not Key then
    return game:GetService("Players").LocalPlayer:Kick("No key provided")
end

local HWID = game:GetService("RbxAnalyticsService"):GetClientId()


local HttpService = game:GetService("HttpService")

local response = request({
    Url = API_URL.."/api/validate",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json",
        ["x-api-key"] = API_SECRET
    },
    Body = HttpService:JSONEncode({
        key = Key,
        hwid = HWID,
        guildId = GUILD_ID
    })
})


local data = HttpService:JSONDecode(response.Body)

if data.success then
    print("Key valid")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/24k-kairi/Zyphrax-Hub/refs/heads/main/Main"))()
else
    game:GetService("Players").LocalPlayer:Kick("Invalid key: "..(data.error or "Unknown error"))
end
