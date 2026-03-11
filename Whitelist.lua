-- CONFIG
local API_URL = "http://YP:6842"
local API_SECRET = "YOUR_API_SECRET"
local GUILD_ID = "1451295256611127378"

-- SERVICES
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- KEY
local Key = getgenv().Key
if not Key or Key == "" then
    Players.LocalPlayer:Kick("No key provided")
    return
end

-- HWID
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()

-- executor request fix
local httprequest = request or http_request or syn and syn.request

if not httprequest then
    Players.LocalPlayer:Kick("Executor not supported")
    return
end

-- REQUEST API
local response = httprequest({
    Url = API_URL .. "/api/validate",
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

if not response or not response.Body then
    Players.LocalPlayer:Kick("API request failed")
    return
end

local data = HttpService:JSONDecode(response.Body)

if data.success then
    print("Key valid")

    loadstring(game:HttpGet("https://raw.githubusercontent.com/24k-kairi/Zyphrax-Hub/refs/heads/main/Main"))()

else
    Players.LocalPlayer:Kick("Invalid key: "..(data.error or "Unknown"))
end
