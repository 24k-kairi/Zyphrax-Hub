local HttpService = game:GetService("HttpService")

local API_URL = "http://YP:3000/api/validate"
local API_SECRET = "48491b998fe7a16954ebe20bb68f195c8ed40d04289bf156dafcbd84a4f5b02f"
local GUILD_ID = "1451295256611127378"

local SCRIPT_URL = "https://raw.githubusercontent.com/24k-kairi/Zyphrax-Hub/refs/heads/main/Main"

local function getHWID()
    if gethwid then
        return gethwid()
    end

    return game:GetService("RbxAnalyticsService"):GetClientId()
end

local function validateKey(key)
    local body = HttpService:JSONEncode({
        key = key,
        hwid = getHWID(),
        guildId = GUILD_ID
    })

    local headers = {
        ["Content-Type"] = "application/json",
        ["x-api-key"] = API_SECRET
    }

    local response = request({
        Url = API_URL,
        Method = "POST",
        Headers = headers,
        Body = body
    })

    local data = HttpService:JSONDecode(response.Body)

    if data.success then
        return true
    else
        return false, data.error
    end
end

local valid, err = validateKey(getgenv().Key)

if not valid then
    game:GetService("Players").LocalPlayer:Kick("Whitelist error: ".. tostring(err))
    return
end

loadstring(game:HttpGet(SCRIPT_URL))()
