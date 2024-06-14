--[[
    __          __   _         ______     _____ ___   _____ ____  ____ 
   / /   __  __/ /__(_)__     / ____ \   / ___//   | / ___// __ \/ __ \
  / /   / / / / //_/ / _ \   / / __ `/   \__ \/ /| | \__ \/ /_/ / /_/ /
 / /___/ /_/ / ,< / /  __/  / / /_/ /   ___/ / ___ |___/ / _, _/ ____/ 
/_____/\__,_/_/|_/_/\___/   \ \__,_/   /____/_/  |_/____/_/ |_/_/      
                             \____/                                    
    This script is not meant for reproduction, any reproduction found will be permanentally terminated without any notice.
]]

-- Webhook URL(S)
MessageLog = '' -- Discord Webhook URL for the Online Players > Message logs
vMenuLog = '' -- Discord Webhook URL for the whole vMenu besides the messages.
WebhookColor = 44270 -- Discord Webhook Color

-- Please do not edit anything below unless you know what you're doing. <3 - Luke
function SendToDiscord(webhook, color, title, description)
    local embed = {
            {
                ["color"] = color,
                ["title"] = title,
                ["description"] = description,
                ["footer"] = {
                    ["text"] = "vMenu Logs",
                },
            }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ embeds = embed }), { ['Content-Type'] = 'application/json' })
end

-- vMenu Events
RegisterNetEvent('vMenu:SendMessageToPlayer')
AddEventHandler('vMenu:SendMessageToPlayer', function(target, message)
    local sourceID = source
    local sourceName = GetPlayerName(sourceID)
    local targetName = GetPlayerName(target)
    sendToDiscord(MessageLog, WebhookColor, "vMenu Event: Private Message", "**From:**\n**ID: " .. sourceID .. "** | " .. sourceName .. "\n\n**To:**\n**ID: " .. target .. "** | " .. targetName .. "\n\n**Message:** `" .. message .. "`")
end)

local function LogEvent(event, title, target)
    local sourceID = source
    local sourceName = GetPlayerName(sourceID)
    local targetName = GetPlayerName(target)
    local description = "**ID: " .. sourceID .. "** | " .. sourceName .. (target and " **->** " .. "**ID: " .. target .. "** | " .. targetName or "")
    sendToDiscord(vMenuLog, WebhookColor, "vMenu Event: " .. title, description)
end

-- Reg. vMenu Events
local vMenuEvents = {
    { 'vMenu:LogPlayerEvent', 'Log Player Event' },
    { 'vMenu:GetPlayerIdentifiers', 'Player Identifiers' },
    { 'vMenu:SaveTeleportLocation', 'Save Teleport Location' },
    { 'vMenu:PmsDisabled', 'Pms Disabled' },
    { 'vMenu:RequestBanList', 'Requested Ban List' },
    { 'vMenu:RequestPlayerUnban', 'Requested Player Unban' },
    { 'cuff:ServerCuffSubject', 'Cuff Subject' },
    { 'vMenu:Logging', 'Logging' },
    { 'vMenu:TempBanPlayer', 'Tempban Event' },
    { 'vMenu:PermBanPlayer', 'Ban Event' },
    { 'vMenu:KickPlayer', 'Kick Event' },
    { 'vMenu:ClearArea', 'Clear Area' },
    { 'vMenu:KillPlayer', 'Kill Player' },
    { 'vMenu:DeathNotification', 'Dead Player' },
    { 'vMenu:SummonPlayer', 'Summon Player' },
    { 'vMenu:UpdateServerWeather', 'Server Weather' },
    { 'vMenu:UpdateServerTime', 'Server Time' }
}

for _, event in ipairs(vMenuEvents) do
    RegisterNetEvent(event[1])
    AddEventHandler(event[1], function(target)
        logEvent(event[1], event[2], target)
    end)
end

-- Resource Name Checker
local ExpName = "vLogs"
local resource = GetCurrentResourceName()
if resource ~= ExpName then
    print("^1[^4" .. ExpName .. "^1] WARNING^0")
    print("Change the resource name to ^4" .. ExpName .. " ^0or else the functionality will not work correctly.")
end

print("The script is up-to-date")
print("Connection to discord successfully established.")