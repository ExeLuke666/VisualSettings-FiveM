local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
local resourceName = '^5[' .. GetCurrentResourceName() .. ']^0'

function checkvers()
    PerformHttpRequest('https://sanandreasstaterp.online/api/versioncheck.json', function(statusCode, response, headers)
        if statusCode = 200 then
            local data = json.decode(response)
            if data and data.version then
                if currentVersion ~= data.version then
                    print(resourceName .. ' ^1is outdated!^0 Current version: ^2' .. currentVersion .. '^0, Latest version: ^2' .. data.version .. '^0')
                    print(resourceName .. ' Update the resource at: ^3' .. data.updateUrl .. '^0')
                else
                    print(resourceName .. ' is up to date. Version: ^2' .. currentVersion .. '^0')
                end
            else
                print(resourceName .. ' Unable to check for updates. Invalid response.')
            end
        else
            print(resourceName .. ' Unable to check for updates. HTTP status code: ' .. statusCode)
        end
    end, 'GET')
end

-- Check the version when the resource starts
Citizen.CreateThread(function()
    checkvers()
end)
