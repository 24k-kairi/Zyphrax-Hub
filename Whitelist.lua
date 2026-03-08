local HttpService = game:GetService("HttpService")

local API_URL = "http://YP:3000/api/validate"
local API_SECRET = "48491b998fe7a16954ebe20bb68f195c8ed40d04289bf156dafcbd84a4f5b02f"
local GUILD_ID = "1451295256611127378"

local SCRIPT_URL = "https://raw.githubusercontent.com/24k-kairi/Zyphrax-Hub/refs/heads/main/Main"

-- GET KEY
local KEY = getgenv().Key
if not KEY or KEY == "" then
    game:GetService("Players").LocalPlayer:Kick("No key provided")
    return
end

-- HWID
local function getHWID()
    if gethwid then
        return gethwid()
    end
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

-- REQUEST FUNCTION (executor compatible)
local httprequest = request or http_request or syn and syn.request

if not httprequest then
    game:GetService("Players").LocalPlayer:Kick("Executor not supported")
    return
end

local function validateKey(key)

    local body = HttpService:JSONEncode({
        key = key,
        hwid = getHWID(),
        guildId = GUILD_ID
    })

    local success, response = pcall(function()
        return httprequest({
            Url = API_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["x-api-key"] = API_SECRET
            },
            Body = body
        })
    end)

    if not success or not response or not response.Body then
        return false, "API request failed"
    end

    local decoded
    local ok = pcall(function()
        decoded = HttpService:JSONDecode(response.Body)
    end)

    if not ok or not decoded then
        return false, "Invalid API response"
    end

    if decoded.success then
        return true
    else
        return false, decoded.error or "Invalid key"
    end
end

-- VALIDATE
local valid, err = validateKey(KEY)

if not valid then
    game:GetService("Players").LocalPlayer:Kick("Whitelist error: ".. tostring(err))
    return
end

-- LOAD SCRIPT
loadstring(game:HttpGet(SCRIPT_URL))()
